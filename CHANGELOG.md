## [Unreleased]

## [1.0.8] - 2026-08-31

- Add `MriHook::RequestHandlers::LedgerAppliesHandler` for the `MRI_S-PMRM_LedgerApplies` endpoint,
  which reports how much of each ledger transaction was settled against which other transaction.
  The resident ledger's `ReferenceNumber` names only one counterpart, so a credit split across
  several charges is invisible there.
- Add `MriHook::Models::LedgerApply`.

## [0.1.0] - 2025-06-29

- Initial release
