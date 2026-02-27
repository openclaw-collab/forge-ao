# FORGE Plugin Audit Synthesis

**Synthesizer:** Synthesis Agent
**Date:** 2026-02-27
**Input Audits:**
- `/docs/forge/audit/latest/docs-audit.md` (Docs Auditor findings)
- `/docs/forge/audit/latest/forge-structure-audit.md` (Structure Auditor findings)
- `/docs/forge/audit/latest/ao-integration-audit.md` (AO Integration Auditor findings)

---

## Executive Summary

### Overall AO-Readiness Score: 65/100

| Category | Score | Status |
|----------|-------|--------|
| Workspace Root Handling | 90/100 | Good |
| Installer Idempotency | 85/100 | Good |
| AO Integration Package | 80/100 | Good |
| State Management | 80/100 | Good |
| Metadata Sync | 75/100 | Acceptable |
| Standalone Remnants | 40/100 | Needs Work |
| Documentation Consistency | 55/100 | Needs Work |

**Assessment:** FORGE has a well-designed AO integration architecture but contains critical drift between documented intent and actual implementation. The plugin correctly implements workspace-root detection, AO metadata sync, and idempotent installation. However, several skill files still contain outdated `Task({subagent_type:...})` patterns that directly contradict the AO-native "no internal subagent" rule.

**Verdict:** FORGE is architecturally sound and ready for implementation, but requires cleanup of contradictory documentation and completion of missing command implementations before AO-native operation can be considered complete.

---

## Cross-Cutting Issues

Issues that appear across multiple audit reports and require coordinated fixes:

### 1. Subagent Spawning Contradiction (Critical)

**Affected Audits:** Docs Audit (Critical), Structure Audit (High)

**The Problem:**
- Architecture documents state: "In AO mode, FORGE NEVER spawns internal subagents"
- Yet `skills/workflows/forge-review.md` contains 5x `Task({subagent_type:...})` examples
- And `skills/workflows/forge-research.md` contains 4x `Task({subagent_type:...})` examples
- `skills/superpowers/subagent-driven-development.md` documents subagent dispatching patterns

**Impact:** Users following skill instructions in AO mode will attempt forbidden operations, leading to confusion and potential system failures.

**Fix Required:**
1. Add AO-mode guards to all subagent-related skills
2. Document AO-mode alternative (generate plan, output `ao spawn` commands)
3. Move standalone-only patterns to clearly marked sections

---

### 2. Implementation Status Confusion (High)

**Affected Audits:** Docs Audit (High), Structure Audit (Medium-High)

**The Problem:**
- `docs/FORGE-POST-IMPLEMENTATION-REVIEW.md` claims `/forge:continue` is missing, but it exists
- `docs/FORGE-IMPROVEMENTS.md` lists ATDD workflow as to-create, but it already exists
- `commands/continue.md` exists but Structure Audit still lists it as missing

**Impact:** Creates confusion about what is actually implemented vs. what remains to be done. May lead to duplicate work or missed requirements.

**Fix Required:**
1. Update FORGE-POST-IMPLEMENTATION-REVIEW.md to mark complete items
2. Update FORGE-IMPROVEMENTS.md to reflect current implementation status
3. Verify all "missing" items actually don't exist before listing them

---

### 3. State File Path Inconsistency (Medium)

**Affected Audits:** Docs Audit (Medium), Structure Audit (Medium)

**The Problem:**
- `skills/core/state-tracking.md` references `.claude/forge/state.json`
- Actual implementation uses `.claude/forge/active-workflow.md`
- `hooks/SessionStart/forge-init.sh` uses correct path

**Impact:** Recovery logic may fail if following documentation; confusion about where state is stored.

**Fix Required:**
1. Update state-tracking.md to reference correct path
2. Audit all documentation for state file references
3. Standardize on `active-workflow.md`

---

### 4. Hook Script Workspace Root Issues (High)

**Affected Audits:** Structure Audit (High)

**The Problem:**
- `hooks/PostToolUse/format-on-save.sh` uses `CLAUDE_PLUGIN_ROOT`
- `hooks/UserPromptSubmit/skill-router-trigger.sh` uses `CLAUDE_PLUGIN_ROOT`
- These assume plugin directory execution context, but in AO mode hooks run from workspace

**Impact:** Hooks may fail or reference wrong directories when running in AO-installed workspaces.

**Fix Required:**
1. Update both hooks to use `workspace-root.sh` helper
2. Change to `WORKSPACE_ROOT` instead of `PLUGIN_ROOT`
3. Test in AO mode

---

### 5. Missing/Partial Command Implementations (Medium-High)

**Affected Audits:** Structure Audit (Medium-High), Docs Audit (Medium)

**The Problem:**
- `/forge:debate` command exists but implementation is incomplete
- `confirm-destructive.sh` hook referenced but not implemented
- Debate templates referenced but not verified to exist

**Impact:** Documented safety features missing; debate system cannot function as designed.

**Fix Required:**
1. Complete `/forge:debate` command implementation
2. Create `confirm-destructive.sh` hook
3. Verify/create debate templates

---

### 6. Agent Registry Inconsistency (Medium)

**Affected Audits:** Docs Audit (Medium)

**The Problem:**
- `workflows/agent-registry.json` contains 19 agents
- Missing debate role agents: advocate, skeptic, operator, synthesizer
- These roles are defined in `forge-workflow.json` but not registered

**Impact:** Debate roles aren't officially registered; may cause lookup failures.

**Fix Required:**
1. Add debate role agents to agent-registry.json
2. Include proper triggers and skills mapping

---

## Critical Path

What MUST be fixed first for AO-native operation:

### Phase 1: Foundation (Blocks Everything)

1. **Fix Hook Scripts** (P0)
   - `hooks/PostToolUse/format-on-save.sh`
   - `hooks/UserPromptSubmit/skill-router-trigger.sh`
   - These must use workspace root, not plugin root

2. **Add AO Mode Guards to Skills** (P0)
   - `skills/workflows/forge-review.md`
   - `skills/workflows/forge-research.md`
   - `skills/superpowers/subagent-driven-development.md`

3. **Fix State File Path** (P0)
   - `skills/core/state-tracking.md`
   - Must reference correct `active-workflow.md` path

### Phase 2: Core Workflows (Required for Basic Operation)

4. **Create Missing `confirm-destructive.sh` Hook** (P0)
   - Referenced in documentation but not implemented
   - Safety-critical for destructive operations

5. **Complete `/forge:debate` Command** (P1)
   - Debate orchestration is core to FORGE workflow
   - Needs plan generation and status checking

6. **Update Agent Registry** (P1)
   - Add debate role agents
   - Required for debate system to function

### Phase 3: Documentation Alignment (Required for Clarity)

7. **Update Implementation Status Documents** (P1)
   - `docs/FORGE-POST-IMPLEMENTATION-REVIEW.md`
   - `docs/FORGE-IMPROVEMENTS.md`

8. **Verify/Create Debate Templates** (P1)
   - `templates/debate/advocate.md`
   - `templates/debate/skeptic.md`
   - `templates/debate/operator.md`
   - `templates/debate/synthesis.md`

---

## Quick Wins

High impact, low effort fixes that can be done immediately:

### 1. Fix State File Path Reference (5 min)
**File:** `skills/core/state-tracking.md`
**Change:** `.claude/forge/state.json` → `.claude/forge/active-workflow.md`
**Impact:** Prevents confusion about state location

### 2. Update Post-Implementation Review (10 min)
**File:** `docs/FORGE-POST-IMPLEMENTATION-REVIEW.md`
**Change:** Mark Item 2 (Missing `/forge:continue`) as complete
**Impact:** Eliminates confusion about implementation status

### 3. Add AO Mode Header to Subagent Skills (15 min)
**Files:**
- `skills/workflows/forge-review.md`
- `skills/workflows/forge-research.md`
- `skills/superpowers/subagent-driven-development.md`

**Change:** Add prominent AO mode compatibility section at top
**Impact:** Prevents users from attempting forbidden operations

### 4. Standardize AO Mode Detection Language (10 min)
**Files:** All command files
**Change:** Standardize on "AO_SESSION environment variable is set"
**Impact:** Reduces confusion from inconsistent terminology

### 5. Update Agent Registry (15 min)
**File:** `workflows/agent-registry.json`
**Change:** Add advocate, skeptic, operator, synthesizer agents
**Impact:** Completes debate role registration

---

## Risk Assessment

### High Risk

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Users attempt subagent spawning in AO mode** | High | High | Add prominent warnings to skills; update docs immediately |
| **Hooks fail in AO workspaces** | Medium | High | Fix workspace root detection before deployment |
| **Debate system doesn't complete** | Medium | Medium | Implement polling mechanism; add manual override |

### Medium Risk

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Metadata sync misses state transitions** | Medium | Medium | Add explicit sync calls at phase transitions |
| **Session naming collisions** | Medium | Low | Use debate-specific naming convention |
| **System prompt length issues** | Low | Medium | Test with AO's append-system-prompt approach |

### Low Risk

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Installation idempotency failures** | Low | Low | Run selftest.sh before deployment |
| **Template file mismatches** | Low | Low | Verify templates exist during installation |

---

## Success Criteria

How we know the rebuild is complete:

### Functional Criteria

- [ ] All hooks use workspace root detection correctly
- [ ] No skill documents subagent spawning without AO mode warnings
- [ ] State file path is consistent across all documentation
- [ ] `/forge:continue` command is fully documented and functional
- [ ] `/forge:debate` command generates plans and checks status
- [ ] `confirm-destructive.sh` hook warns on destructive operations
- [ ] All debate role agents are registered in agent-registry.json
- [ ] Debate templates exist and match schema specification

### Integration Criteria

- [ ] FORGE works correctly in AO mode (AO_SESSION set)
- [ ] Metadata sync populates AO metadata files with forge_* keys
- [ ] Installer is idempotent (running twice produces same result)
- [ ] System prompt loads correctly in AO sessions
- [ ] Debate orchestration completes end-to-end

### Documentation Criteria

- [ ] No contradictions between architecture and implementation docs
- [ ] Implementation status documents reflect actual state
- [ ] All referenced files exist
- [ ] AO mode detection language is consistent
- [ ] CHANGELOG accurately reflects changes

### Quality Criteria

- [ ] All P0 tasks completed
- [ ] All P1 tasks completed or explicitly deferred
- [ ] Selftest.sh passes in AO mode
- [ ] End-to-end debate flow test passes
- [ ] Metadata sync verification passes

---

## Summary

FORGE's AO-native rebuild is **architecturally sound** but has **documentation drift** that must be addressed. The core AO integration package demonstrates solid understanding of AO architecture and is ready for use. The primary remaining work is:

1. **Immediate (P0):** Fix hook scripts and add AO mode guards to skills
2. **Short-term (P1):** Complete debate command and verify templates
3. **Polish (P2):** Align documentation with implementation

The plugin can operate in AO mode today, but users may encounter confusion due to contradictory documentation. Fixing the critical path items will bring FORGE to full AO-native readiness.

---

**Synthesis completed by:** Synthesis Agent
**Date:** 2026-02-27
**Next Steps:** Implement action checklist in priority order
