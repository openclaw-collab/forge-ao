# FORGE Plugin Rebuild Action Checklist

**Generated from:** Synthesis of three audit reports
**Date:** 2026-02-27
**Priority Legend:** P0 (Blocking), P1 (Critical), P2 (Important)

---

## Task 1: Fix Hook Scripts to Use Workspace Root

**Priority:** P0
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/hooks/PostToolUse/format-on-save.sh`
- `/Users/muadhsambul/forge-plugin-agent/hooks/UserPromptSubmit/skill-router-trigger.sh`

**Acceptance Criteria:**
- [ ] Both scripts source `../_lib/workspace-root.sh`
- [ ] Both scripts use `get_workspace_root()` instead of `CLAUDE_PLUGIN_ROOT`
- [ ] Scripts change to workspace root before executing
- [ ] No references to `CLAUDE_PLUGIN_ROOT` remain in hook scripts

**Validation:**
```bash
# Test in AO-installed workspace
grep -r "CLAUDE_PLUGIN_ROOT" hooks/
# Should return no results (except in comments if documenting)

# Verify workspace root detection works
source hooks/_lib/workspace-root.sh
get_workspace_root
# Should output correct workspace path
```

---

## Task 2: Add AO Mode Guards to Subagent Skills

**Priority:** P0
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/skills/workflows/forge-review.md`
- `/Users/muadhsambul/forge-plugin-agent/skills/workflows/forge-research.md`
- `/Users/muadhsambul/forge-plugin-agent/skills/superpowers/subagent-driven-development.md`

**Acceptance Criteria:**
- [ ] Each file has "AO Mode Compatibility" section at top (after frontmatter)
- [ ] Section clearly states: "In AO mode, DO NOT spawn internal subagents"
- [ ] Section documents AO mode behavior: generate plan, output `ao spawn` commands
- [ ] Section documents standalone mode behavior with clear warning
- [ ] All `Task({subagent_type:...})` examples moved to standalone-only section

**Validation:**
```bash
# Check for AO mode section
grep -A 5 "AO Mode Compatibility" skills/workflows/forge-review.md
grep -A 5 "AO Mode Compatibility" skills/workflows/forge-research.md
grep -A 5 "AO Mode Compatibility" skills/superpowers/subagent-driven-development.md

# Verify standalone warnings exist
grep -i "standalone only" skills/workflows/forge-review.md
grep -i "standalone only" skills/workflows/forge-research.md
```

---

## Task 3: Fix State File Path in Documentation

**Priority:** P0
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/skills/core/state-tracking.md`

**Acceptance Criteria:**
- [ ] All references to `.claude/forge/state.json` changed to `.claude/forge/active-workflow.md`
- [ ] Line 134 specifically updated (as identified in audit)
- [ ] No references to incorrect path remain in file

**Validation:**
```bash
# Verify fix
grep "state.json" skills/core/state-tracking.md
# Should return no results

grep "active-workflow.md" skills/core/state-tracking.md
# Should show correct references
```

---

## Task 4: Create Missing confirm-destructive.sh Hook

**Priority:** P0
**Files to Create:**
- `/Users/muadhsambul/forge-plugin-agent/hooks/PreToolUse/confirm-destructive.sh`

**Acceptance Criteria:**
- [ ] File exists at correct location
- [ ] Sources `../_lib/workspace-root.sh`
- [ ] Warns before modifying git-related files (`.git/`, `.gitignore`)
- [ ] Warns before overwriting large files (>10KB)
- [ ] Prompts for user confirmation with y/N
- [ ] Exits with code 1 if user declines
- [ ] Has executable permissions

**Validation:**
```bash
# Verify file exists and is executable
ls -la hooks/PreToolUse/confirm-destructive.sh

# Test git file warning
./hooks/PreToolUse/confirm-destructive.sh .git/config Write
# Should prompt for confirmation

# Test large file warning
echo "$(yes 'x' | head -c 11000)" > /tmp/large-test.txt
./hooks/PreToolUse/confirm-destructive.sh /tmp/large-test.txt Write
# Should prompt for confirmation
```

---

## Task 5: Update Post-Implementation Review Document

**Priority:** P1
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/docs/FORGE-POST-IMPLEMENTATION-REVIEW.md`

**Acceptance Criteria:**
- [ ] Section 5.1 Item 2 (Missing `/forge:continue`) marked as complete
- [ ] Reference to `/commands/continue.md` added
- [ ] Other "missing" items verified to actually exist or not
- [ ] File counts updated if needed

**Validation:**
```bash
# Verify update
grep -A 3 "Missing.*continue" docs/FORGE-POST-IMPLEMENTATION-REVIEW.md
# Should show "COMPLETE" or similar status

# Verify continue.md exists
ls -la commands/continue.md
```

---

## Task 6: Update FORGE-IMPROVEMENTS Document

**Priority:** P1
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/docs/FORGE-IMPROVEMENTS.md`

**Acceptance Criteria:**
- [ ] Section 1.1 updated to reflect ATDD workflow exists
- [ ] Section 3.1 updated to show `skills/quality/atdd-workflow.md` as implemented
- [ ] Other implemented items marked as complete
- [ ] Remaining work accurately reflects actual state

**Validation:**
```bash
# Verify ATDD workflow exists
ls -la skills/quality/atdd-workflow.md

# Check document reflects implementation
grep -i "atdd" docs/FORGE-IMPROVEMENTS.md
# Should show as implemented, not "to create"
```

---

## Task 7: Update Agent Registry with Debate Roles

**Priority:** P1
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/workflows/agent-registry.json`

**Acceptance Criteria:**
- [ ] "advocate" agent added with proper triggers and skills
- [ ] "skeptic" agent added with proper triggers and skills
- [ ] "operator" agent added with proper triggers and skills
- [ ] "synthesizer" agent added with proper triggers and skills
- [ ] Each agent has debate-related skills mapping
- [ ] JSON is valid (passes validation)

**Validation:**
```bash
# Verify agents added
grep -E '"(advocate|skeptic|operator|synthesizer)"' workflows/agent-registry.json

# Validate JSON
node -e "JSON.parse(require('fs').readFileSync('workflows/agent-registry.json'))" && echo "Valid JSON"
```

---

## Task 8: Complete /forge:debate Command Implementation

**Priority:** P1
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/commands/debate.md`

**Acceptance Criteria:**
- [ ] Command supports `--plan --id <debate-id>` to generate debate plan
- [ ] Command supports `--check --id <debate-id>` to check debate gate
- [ ] Plan generation creates `docs/forge/debate/<id>/debate-plan.md`
- [ ] Plan includes role-specific prompts for advocate, skeptic, operator, synthesizer
- [ ] Check command returns PASSED/FAILED based on synthesis.md existence
- [ ] Command outputs AO spawn commands for debate roles

**Validation:**
```bash
# Verify command file exists and is complete
wc -l commands/debate.md
# Should show substantial content (>200 lines)

# Check for required sections
grep -i "plan" commands/debate.md
grep -i "check" commands/debate.md
grep -i "ao spawn" commands/debate.md
```

---

## Task 9: Verify/Create Debate Templates

**Priority:** P1
**Files to Verify/Create:**
- `/Users/muadhsambul/forge-plugin-agent/templates/debate/advocate.md`
- `/Users/muadhsambul/forge-plugin-agent/templates/debate/skeptic.md`
- `/Users/muadhsambul/forge-plugin-agent/templates/debate/operator.md`
- `/Users/muadhsambul/forge-plugin-agent/templates/debate/synthesis.md`

**Acceptance Criteria:**
- [ ] All four template files exist
- [ ] Each template matches specification in `docs/forge/debate-schema.md`
- [ ] advocate.md has role-specific instructions
- [ ] skeptic.md has role-specific instructions
- [ ] operator.md has role-specific instructions
- [ ] synthesis.md has synthesis instructions

**Validation:**
```bash
# Verify templates exist
ls -la templates/debate/

# Check content
grep -i "advocate" templates/debate/advocate.md
grep -i "skeptic" templates/debate/skeptic.md
grep -i "operator" templates/debate/operator.md
grep -i "synthesis" templates/debate/synthesis.md
```

---

## Task 10: Create Phase Handoffs Documentation

**Priority:** P2
**Files to Create:**
- `/Users/muadhsambul/forge-plugin-agent/docs/forge/phase-handoffs.md`

**Acceptance Criteria:**
- [ ] Document created with phase handoff specification
- [ ] Lists all 10 phases with input/output definitions
- [ ] Documents what metadata is passed between phases
- [ ] Documents how AO coordinates phase transitions
- [ ] Includes diagram or table showing handoff flow

**Validation:**
```bash
# Verify file exists
ls -la docs/forge/phase-handoffs.md

# Check content
head -50 docs/forge/phase-handoffs.md
# Should show phase handoff documentation
```

---

## Task 11: Standardize AO Mode Detection Language

**Priority:** P2
**Files to Modify:**
- All files in `/Users/muadhsambul/forge-plugin-agent/commands/`
- All files in `/Users/muadhsambul/forge-plugin-agent/skills/`
- All files in `/Users/muadhsambul/forge-plugin-agent/docs/`

**Acceptance Criteria:**
- [ ] Standardized on "AO_SESSION environment variable is set"
- [ ] All "AO_SESSION set" changed to standard
- [ ] All "AO_SESSION present" changed to standard
- [ ] All "AO_SESSION is set" changed to standard
- [ ] All "AO_SESSION env var" changed to standard

**Validation:**
```bash
# Find inconsistent usage
grep -r "AO_SESSION set" --include="*.md" . | grep -v "environment variable"
grep -r "AO_SESSION present" --include="*.md" .
grep -r "AO_SESSION is set" --include="*.md" . | grep -v "environment variable"

# Should return minimal results after fix
```

---

## Task 12: Update CHANGELOG Accuracy

**Priority:** P2
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/CHANGELOG.md`

**Acceptance Criteria:**
- [ ] Verify claim that Task examples removed from skills
- [ ] Either actually remove Task examples or update changelog
- [ ] Ensure changelog accurately reflects current state
- [ ] Add note about AO mode warnings if Task examples remain

**Validation:**
```bash
# Check for Task examples in skills
grep -r "subagent_type" skills/

# Verify changelog accuracy
grep -i "task.*example" CHANGELOG.md
grep -i "subagent" CHANGELOG.md
```

---

## Task 13: Add Metadata Sync for Missing Keys

**Priority:** P2
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/hooks/PostToolUse/ao-sync-metadata.sh`

**Acceptance Criteria:**
- [ ] Adds `forge_branch` key from active-workflow.md
- [ ] Adds `forge_issue` key from active-workflow.md
- [ ] Adds `forge_version` key from active-workflow.md
- [ ] Adds `forge_started_at` key from active-workflow.md
- [ ] All keys properly formatted for AO metadata file

**Validation:**
```bash
# Check current keys
grep "forge_" hooks/PostToolUse/ao-sync-metadata.sh

# Verify new keys added
grep -E "forge_(branch|issue|version|started_at)" hooks/PostToolUse/ao-sync-metadata.sh
```

---

## Task 14: Remove Standalone Mode Remnants

**Priority:** P2
**Files to Modify:**
- `/Users/muadhsambul/forge-plugin-agent/commands/swarm.md`
- `/Users/muadhsambul/forge-plugin-agent/commands/start.md`
- `/Users/muadhsambul/forge-plugin-agent/skills/workflows/forge-build.md`

**Acceptance Criteria:**
- [ ] swarm.md standalone mode section removed (lines 57-71)
- [ ] start.md standalone mode flow section removed (lines 135-147)
- [ ] forge-build.md subagent dispatching marked as standalone-only
- [ ] AO mode alternative documented in each file

**Validation:**
```bash
# Verify standalone sections removed or marked
grep -i "standalone" commands/swarm.md
grep -i "standalone" commands/start.md
grep -i "standalone" skills/workflows/forge-build.md

# Should show clear standalone-only markings or be removed
```

---

## Task 15: Run Full Integration Test

**Priority:** P1
**Files to Use:**
- `/Users/muadhsambul/forge-plugin-agent/integrations/agent-orchestrator/selftest.sh`

**Acceptance Criteria:**
- [ ] Installer idempotency test passes
- [ ] Metadata sync test passes
- [ ] Hook execution test passes
- [ ] State tracking test passes
- [ ] All tests pass in AO mode simulation

**Validation:**
```bash
# Run selftest
cd /Users/muadhsambul/forge-plugin-agent
./integrations/agent-orchestrator/selftest.sh

# Should show all tests passing
```

---

## Task Completion Summary

| Task | Priority | Status | Owner |
|------|----------|--------|-------|
| 1. Fix Hook Scripts | P0 | Pending | TBD |
| 2. Add AO Mode Guards | P0 | Pending | TBD |
| 3. Fix State File Path | P0 | Pending | TBD |
| 4. Create confirm-destructive.sh | P0 | Pending | TBD |
| 5. Update Post-Implementation Review | P1 | Pending | TBD |
| 6. Update FORGE-IMPROVEMENTS | P1 | Pending | TBD |
| 7. Update Agent Registry | P1 | Pending | TBD |
| 8. Complete /forge:debate | P1 | Pending | TBD |
| 9. Verify Debate Templates | P1 | Pending | TBD |
| 10. Create Phase Handoffs Doc | P2 | Pending | TBD |
| 11. Standardize AO Language | P2 | Pending | TBD |
| 12. Update CHANGELOG | P2 | Pending | TBD |
| 13. Add Metadata Keys | P2 | Pending | TBD |
| 14. Remove Standalone Remnants | P2 | Pending | TBD |
| 15. Run Integration Test | P1 | Pending | TBD |

---

**Checklist generated by:** Synthesis Agent
**Date:** 2026-02-27
**Next Action:** Begin Task 1 (Fix Hook Scripts)
