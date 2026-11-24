# Capital18 online – pașii de setup

## 1. Baza de date (Supabase)
1. Deschide proiectul tău pe supabase.com.
2. **SQL Editor → New query** → lipește tot conținutul din `schema.sql` → **Run**.
3. **Authentication → Sign In / Providers → Email**: oprește **Confirm email** → Save.
   (Conturile se fac cu nume de utilizator, nu cu e-mail real, deci nu are cui să se trimită confirmarea.)
4. **Project Settings → API Keys**: copiază cheia **anon public** (sau **Publishable key**).
   NU folosi cheia `service_role` / `secret`.

## 2. Cheia în aplicație
În `index.html` caută rândul:

    const SUPABASE_KEY='PUNE_AICI_CHEIA_ANON';

și înlocuiește `PUNE_AICI_CHEIA_ANON` cu cheia copiată. Adresa proiectului (`wawkhmqthbntzfczstzd`) e deja pusă.

## 3. Online (Vercel)
1. github.com → **New repository** → `capital18` → **uploading an existing file** → trage toate fișierele din folderul ăsta → **Commit**.
2. vercel.com → **Sign in with GitHub** → **Add New → Project** → alege `capital18` → **Deploy**.
3. Primești un link de forma `capital18.vercel.app`. Ăla e linkul pe care îl dai colegilor.
4. Înapoi în Supabase: **Authentication → URL Configuration → Site URL** = linkul de la Vercel.

## Bine de știut
- Butoanele „Elev demo / Profesor demo” merg fără internet, cu date de test salvate doar pe telefon. Bune pentru prezentarea la juriu.
- Pe planul gratuit, Supabase pune proiectul pe pauză după 7 zile fără activitate. Îl repornești din dashboard.
- Prietenia e într-un singur sens: tu îl adaugi pe el, el te adaugă pe tine.
- Orice utilizator logat poate citi profilurile (necesar pentru clasament). Nu salvați date sensibile în aplicație.
- Dacă schimbi aplicația după ce ai urcat-o: urci fișierele noi pe GitHub, iar Vercel o actualizează singur.
