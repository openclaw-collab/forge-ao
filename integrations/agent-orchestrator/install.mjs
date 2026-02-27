#!/usr/bin/env node
/**
 * FORGE Agent Orchestrator Integration Installer
 *
 * Installs FORGE hooks and configuration into an AO workspace.
 * Usage: node install.mjs [--workspace <path>] [--mode ao|standalone]
 */

import { existsSync, copyFileSync, mkdirSync, readFileSync, writeFileSync, chmodSync, readdirSync } from 'fs';
import { dirname, join, resolve } from 'path';
import { fileURLToPath } from 'url';
import { execFileSync } from 'child_process';

const __dirname = dirname(fileURLToPath(import.meta.url));

// Parse arguments
function parseArgs() {
  const args = process.argv.slice(2);
  const options = {
    workspace: process.cwd(),
    mode: null // auto-detect
  };

  for (let i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--workspace':
        options.workspace = args[++i] || process.cwd();
        break;
      case '--mode':
        options.mode = args[++i];
        break;
      case '--help':
      case '-h':
        console.log(`
Usage: node install.mjs [options]

Options:
  --workspace <path>   Workspace directory (default: cwd)
  --mode <ao|standalone>  Installation mode (default: auto-detect)
  --help, -h           Show this help

Auto-detection:
  If AO_SESSION environment variable is set, mode defaults to 'ao'.
  Otherwise, defaults to 'standalone'.
`);
        process.exit(0);
    }
  }

  // Auto-detect mode
  if (!options.mode) {
    options.mode = process.env.AO_SESSION ? 'ao' : 'standalone';
  }

  return options;
}

// Get workspace root (git top-level or provided path)
function getWorkspaceRoot(workspacePath) {
  try {
    const gitRoot = execFileSync('git', ['rev-parse', '--show-toplevel'], {
      cwd: workspacePath,
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'ignore']
    }).trim();
    return gitRoot;
  } catch {
    return resolve(workspacePath);
  }
}

// Read existing settings.json or return empty object
function readSettings(settingsPath) {
  if (!existsSync(settingsPath)) {
    return {};
  }
  try {
    const content = readFileSync(settingsPath, 'utf8');
    return JSON.parse(content);
  } catch (e) {
    console.warn(`Warning: Could not parse ${settingsPath}, starting fresh`);
    return {};
  }
}

// Deep merge objects
function deepMerge(target, source) {
  const result = { ...target };
  for (const key in source) {
    if (source[key] && typeof source[key] === 'object' && !Array.isArray(source[key])) {
      result[key] = deepMerge(result[key] || {}, source[key]);
    } else if (Array.isArray(source[key])) {
      // For arrays, merge uniquely
      const existing = result[key] || [];
      result[key] = [...new Set([...existing, ...source[key]])];
    } else {
      result[key] = source[key];
    }
  }
  return result;
}

// Check if hook entry already exists
function hookExists(hooks, command) {
  return hooks.some(h => h.command && h.command.includes(command));
}

// Ensure directory exists
function ensureDir(dir) {
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }
}

// Copy hook file and make executable
function installHook(sourcePath, destPath) {
  copyFileSync(sourcePath, destPath);
  chmodSync(destPath, 0o755);
}

// Find FORGE root (3 levels up from integrations/agent-orchestrator)
function findForgeRoot() {
  return resolve(__dirname, '../..');
}

// Main installation
async function main() {
  const options = parseArgs();
  const workspaceRoot = getWorkspaceRoot(options.workspace);
  const forgeRoot = findForgeRoot();

  console.log(`Installing FORGE in ${options.mode} mode...`);
  console.log(`  Workspace: ${workspaceRoot}`);
  console.log(`  FORGE root: ${forgeRoot}`);

  // Ensure .claude directory exists
  const claudeDir = join(workspaceRoot, '.claude');
  ensureDir(claudeDir);

  // Create forge directories
  const forgeDir = join(claudeDir, 'forge');
  const forgeHooksDir = join(forgeDir, 'hooks');
  ensureDir(forgeDir);
  ensureDir(forgeHooksDir);
  ensureDir(join(forgeDir, 'snapshots'));
  ensureDir(join(forgeDir, 'archive'));

  // Copy system prompt
  const systemPromptSource = join(__dirname, 'forge-system-prompt.md');
  const systemPromptDest = join(forgeDir, 'forge-system-prompt.md');
  if (existsSync(systemPromptSource)) {
    copyFileSync(systemPromptSource, systemPromptDest);
    console.log('  ✓ Installed forge-system-prompt.md');
  }

  // Copy agent rules (optional)
  const rulesSource = join(__dirname, 'forge-agent-rules.md');
  if (existsSync(rulesSource)) {
    copyFileSync(rulesSource, join(forgeDir, 'forge-agent-rules.md'));
    console.log('  ✓ Installed forge-agent-rules.md');
  }

  // Copy FORGE hook scripts
  const hooksSourceDir = join(forgeRoot, 'hooks');
  const hooksToCopy = [
    '_lib',
    'SessionStart',
    'PreToolUse',
    'PostToolUse',
    'PreCompact'
  ];

  for (const hookDir of hooksToCopy) {
    const sourcePath = join(hooksSourceDir, hookDir);
    if (!existsSync(sourcePath)) continue;

    const destPath = join(forgeHooksDir, hookDir);
    ensureDir(destPath);

    const files = readdirSync(sourcePath);
    for (const file of files) {
      const fileSource = join(sourcePath, file);
      const fileDest = join(destPath, file);
      installHook(fileSource, fileDest);
    }
  }
  console.log('  ✓ Installed FORGE hooks');

  // Build FORGE settings - avoiding duplicates
  const existingSettings = readSettings(join(claudeDir, 'settings.json'));
  const hooks = existingSettings.hooks || {};

  // SessionStart hooks
  if (!hooks.SessionStart) hooks.SessionStart = [];
  if (!hookExists(hooks.SessionStart, 'forge-init.sh')) {
    hooks.SessionStart.push({
      type: "shell",
      command: join(forgeHooksDir, 'SessionStart/forge-init.sh')
    });
  }

  // PreToolUse hooks
  if (!hooks.PreToolUse) hooks.PreToolUse = [];
  if (!hookExists(hooks.PreToolUse, 'block-env-edits.sh')) {
    hooks.PreToolUse.push({
      type: "shell",
      command: join(forgeHooksDir, 'PreToolUse/block-env-edits.sh'),
      tools: ["Edit", "Write"],
      when: "before"
    });
  }
  if (!hookExists(hooks.PreToolUse, 'block-lockfile-edits.sh')) {
    hooks.PreToolUse.push({
      type: "shell",
      command: join(forgeHooksDir, 'PreToolUse/block-lockfile-edits.sh'),
      tools: ["Edit", "Write"],
      when: "before"
    });
  }

  // PostToolUse hooks
  if (!hooks.PostToolUse) hooks.PostToolUse = [];
  if (!hookExists(hooks.PostToolUse, 'ao-sync-metadata.sh')) {
    hooks.PostToolUse.push({
      type: "shell",
      command: join(forgeHooksDir, 'PostToolUse/ao-sync-metadata.sh'),
      tools: ["Write", "Edit"],
      when: "after"
    });
  }
  if (!hookExists(hooks.PostToolUse, 'type-check.sh')) {
    hooks.PostToolUse.push({
      type: "shell",
      command: join(forgeHooksDir, 'PostToolUse/type-check.sh'),
      tools: ["Write", "Edit"],
      when: "after",
      pattern: "*.ts|*.tsx"
    });
  }
  if (!hookExists(hooks.PostToolUse, 'lint-check.sh')) {
    hooks.PostToolUse.push({
      type: "shell",
      command: join(forgeHooksDir, 'PostToolUse/lint-check.sh'),
      tools: ["Write", "Edit"],
      when: "after"
    });
  }

  // PreCompact hooks
  if (!hooks.PreCompact) hooks.PreCompact = [];
  if (!hookExists(hooks.PreCompact, 'pre-compact.sh')) {
    hooks.PreCompact.push({
      type: "shell",
      command: join(forgeHooksDir, 'PreCompact/pre-compact.sh')
    });
  }

  const forgeSettings = { hooks };

  // Write settings
  const settingsPath = join(claudeDir, 'settings.json');
  writeFileSync(settingsPath, JSON.stringify(forgeSettings, null, 2));
  console.log('  ✓ Updated .claude/settings.json');

  // Create initial state file if missing
  const stateFile = join(forgeDir, 'active-workflow.md');
  if (!existsSync(stateFile)) {
    const initialState = `---
workflow: forge
version: "0.4.0"
objective: null
phase: null
status: null
started_at: null
last_updated: null
completed_phases: []
next_phase: null
branch: null
issue: null
---

# FORGE Workflow State

This file tracks the current FORGE workflow state.
Use \`/forge:start\` or \`/forge:help\` to begin.
`;
    writeFileSync(stateFile, initialState);
    console.log('  ✓ Created active-workflow.md');
  }

  // Copy forge-state.sh script
  const scriptsSourceDir = join(forgeRoot, 'scripts');
  const scriptsDestDir = join(forgeDir, 'scripts');
  ensureDir(scriptsDestDir);

  if (existsSync(join(scriptsSourceDir, 'forge-state.sh'))) {
    installHook(join(scriptsSourceDir, 'forge-state.sh'), join(scriptsDestDir, 'forge-state.sh'));
    console.log('  ✓ Installed forge-state.sh');
  }

  // Create docs/forge directory
  ensureDir(join(workspaceRoot, 'docs/forge'));

  console.log('\n✅ FORGE installation complete!');
  console.log(`\nNext steps:`);
  console.log(`  1. Start a workflow: /forge:start`);
  if (options.mode === 'ao') {
    console.log(`  2. FORGE metadata will sync to AO dashboard`);
  } else {
    console.log(`  2. FORGE will work in standalone mode`);
  }
}

main().catch(err => {
  console.error('Installation failed:', err.message);
  process.exit(1);
});
