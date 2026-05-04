# Authentication, Authorization & Injection Prevention

## 3. SQL Injection Prevention

### NEVER Concatenate SQL
```typescript
// DANGEROUS
const query = `SELECT * FROM users WHERE email = '${userEmail}'`
```

### ALWAYS Use Parameterized Queries
```typescript
const { data } = await supabase
  .from('users')
  .select('*')
  .eq('email', userEmail)

// Or with raw SQL
await db.query('SELECT * FROM users WHERE email = $1', [userEmail])
```

### Verification Steps
- [ ] All database queries use parameterized queries
- [ ] No string concatenation in SQL
- [ ] ORM/query builder used correctly

## 4. Authentication & Authorization

### JWT Token Handling
```typescript
// WRONG: localStorage (vulnerable to XSS)
localStorage.setItem('token', token)

// CORRECT: httpOnly cookies
res.setHeader('Set-Cookie',
  `token=${token}; HttpOnly; Secure; SameSite=Strict; Max-Age=3600`)
```

### Authorization Checks
```typescript
export async function deleteUser(userId: string, requesterId: string) {
  const requester = await db.users.findUnique({ where: { id: requesterId } })
  if (requester.role !== 'admin') {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 403 })
  }
  await db.users.delete({ where: { id: userId } })
}
```

### Row Level Security (Supabase)
```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users view own data"
  ON users FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users update own data"
  ON users FOR UPDATE USING (auth.uid() = id);
```

### Verification Steps
- [ ] Tokens stored in httpOnly cookies (not localStorage)
- [ ] Authorization checks before sensitive operations
- [ ] Row Level Security enabled in Supabase
- [ ] Role-based access control implemented
- [ ] Session management secure
