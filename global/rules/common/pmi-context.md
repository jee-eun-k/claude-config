# PMI Platform Context

> Always-available context for all PMI-related projects. PM International Korea's microservice platform on Azure AKS.

## Project Map

| Repo | Path | Stack | Purpose |
|------|------|-------|---------|
| **pmi-workspace** | `~/Development/pmi-workspace/` | Next.js 15, React 19 | BRS workspace frontend (`dev-workspace.pmi-korea.com`) |
| **pmi-authorization** | `~/Development/pmi-authorization/` | Next.js 15 + Spring Boot 3.2 | RBAC admin — users, roles, permissions, menus (`dev-auth.pmi-korea.com`) |
| **pmi-microservice** | `~/Development/pmi-microservice/` | Java 17, Spring Boot 3, JPA, QueryDSL | Backend services: gateway, member, promotion, trip, virtual-account |
| **pmi-common** | `~/Development/pmi-common/` | Java 17, Spring Boot 3.2 | Shared library (DTOs, enums, encryption) + Spring Cloud Config Server |
| **pmi-infra-repo** | `~/Development/pmi-infra-repo/` | Helm, Argo CD | GitOps deployment — 21 apps on AKS |
| **pmi-backoffice** | `~/Development/pmi-backoffice/` | Next.js 14, Ant Design + Shadcn | Compliance & office support backoffice |
| **pmi-web** | `~/Development/pmi-web/` | Java 7, Spring 4, MyBatis, Next.js 13 | Legacy monolith (myoffice, shopping, board, policy pages) |
| **pmi-povas** | `~/Development/pmi-povas/` | Spring Boot, Java 17 | Legacy POVAS integration (SQL Managed Instance) |

## Key Architecture Facts

- **Auth**: Keycloak SSO (realm: `pmi-workspace`, PKCE flow) at `dev-sso.pmi-korea.com`
- **Gateway**: Spring Cloud Gateway (:8080) validates JWT, routes `/api/*` to services via Eureka
- **Permission**: ALL services call `pmi-authorization-dev` for permission resolution (`GET /access-context/permissions`)
- **Database**: PostgreSQL at `10.100.7.4:5432` (databases: pmi, pmi-authorization, pmi-member, pmi-keycloak)
- **Cache**: Redis Sentinel (2 nodes)
- **Registry**: `pmicr.azurecr.io` (Azure ACR)
- **Domains**: `dev-*.pmi-korea.com` (workspace, auth, sso, authz)
- **SaaS transition**: Hong Kong as second tenant — auth service tenant isolation is the linchpin

## Gateway Routes

```
/api/brs/**              → lb://bonus-service
/api/member/**           → lb://pmi-member
/api/va/**               → lb://virtual-account-service
/api/msg/**              → lb://messaging-service
/api/trip/**             → lb://pmi-trip
/api/promotion-config/** → lb://promotion-config-service
```

## Frontend Convention

- Never use `/api/` prefix in frontend routes — use `/auth-api/` or `/service-api/` (Nginx conflict)
- UI: Shadcn + Tailwind (new), Ant Design (legacy backoffice)
- Dialogs: Use unified components from `src/components/dialogs/`
