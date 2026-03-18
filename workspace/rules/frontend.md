# Frontend Rules (React/Next.js)

## 1. API Route Naming

Never use `/api/` prefix — it conflicts with the Nginx proxy. Use `/auth-api/` for authentication routes and `/service-api/` for all other business logic routes.

---

## 2. Dialog Components

Always use unified dialog components from `src/components/dialogs/`. Never use MUI Dialog directly.

Available dialogs:
- `CommonDialog` - General purpose
- `ConfirmDialog` - Confirmation prompts
- `FormDialog` - Forms with validation (React Hook Form + Zod)
- `DetailDialog` - Read-only detail views
- `SearchDialog` - Search and select

---

## 3. Pagination with React Query

Never include page number in `queryKey` — it causes pagination resets.

```typescript
const { data, refetch } = useQuery({
  queryKey: ['/api-endpoint', filters, paginationModel.pageSize], // no page here
  queryFn: () => fetchData({ page: paginationModel.page, ...filters }),
  refetchOnWindowFocus: false,
})
useEffect(() => { refetch() }, [paginationModel.page, refetch])
```

---

## 4. Data Flow

Strict order: **API → React Query → Component State → UI**

---

## 5. UI Framework

Use **Shadcn UI + Tailwind** for all new components. MUI legacy code is OK to keep; `CustomDataGrid` and `StatusChip` are approved MUI exceptions.

---

## Quick Reference

| Need | Use | Location |
|------|-----|----------|
| Dialog form | `FormDialog` + React Hook Form | `src/components/dialogs/` |
| Data table | `CustomDataGrid` + React Query | `src/sections/` |
| API call | `useQuery()` hook | Custom hook in `src/hooks/` |
| Shared state | React Context | `src/context/` |
| Styling | Shadcn + Tailwind | — |
| Validation | Zod schema | Form component |
| Authentication | Keycloak SSO via context | `src/context/AuthContext` |
