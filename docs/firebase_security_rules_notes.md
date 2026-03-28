# Firebase Security Rules Notes

Use this file as the basis for the report section that explains how Firebase rules protect user data.

## Questions to Answer

1. Which collections exist?
2. Who can read each collection?
3. Who can create each document?
4. Who can update each document?
5. Who can delete each document?
6. Which fields should only be editable by the owner?
7. Are there any admin-only paths?

## Report Talking Points

- Access should be scoped to authenticated users where appropriate.
- User-owned data should be restricted with checks against `request.auth.uid`.
- Public reads should be explicitly justified instead of left open by default.
- Validation rules should protect document shape where possible.
- Broad `allow read, write: if request.auth != null;` rules should be avoided unless the collection truly requires them.

## Final Rules Placeholder

```txt
Paste the final Firebase rules here before submission.
```
