# ClearSpend Website

A responsive, static three-page website for ClearSpend:

- `index.html` — landing page
- `about.html` — founder and company background
- `contact.html` — contact portal
- `assets/styles.css` — visual design and responsive layout
- `js/contact.js` — contact form behavior

## Preview locally

Open `index.html` in a browser, or use VS Code's Live Server extension.

## Important: configure the contact form

The form is intentionally set to a placeholder email address.

1. Open `js/contact.js`.
2. Replace `hello@clearspend.example` with your actual business email.
3. Publish the site.

This static version opens the visitor's email app with the message pre-filled. For a server-side form that works even when a visitor does not use a desktop email client, connect the form to a service such as Formspree, Netlify Forms, or a small serverless endpoint.

## Publish options

- GitHub Pages: free for static sites
- Netlify: simple drag-and-drop deploy plus optional form handling
- Cloudflare Pages: fast static hosting
- Google Cloud Storage + Cloud CDN: good fit if you want it in GCP
- OCI Object Storage + CDN: good fit if you want to showcase OCI experience
