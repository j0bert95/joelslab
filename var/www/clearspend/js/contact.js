/*
  Before publishing:
  Replace hello@clearspend.example with your actual business email address.
  This static-site version opens the visitor's default email app with the inquiry pre-filled.
*/
const DESTINATION_EMAIL = "joelrsnider95@gmail.com";

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("contact-form");
  const status = document.getElementById("form-status");
  if (!form) return;

  form.addEventListener("submit", (event) => {
    event.preventDefault();

    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }

    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const company = document.getElementById("company").value.trim() || "Not provided";
    const platform = document.getElementById("platform").value || "Not provided";
    const message = document.getElementById("message").value.trim();

    const subject = encodeURIComponent(`ClearSpend inquiry from ${name}`);
    const body = encodeURIComponent(
`Name: ${name}
Work email: ${email}
Company: ${company}
Preferred cloud platform: ${platform}

Inquiry:
${message}`
    );

    status.textContent = "Opening your email app with your inquiry pre-filled...";
    window.location.href = `mailto:${DESTINATION_EMAIL}?subject=${subject}&body=${body}`;
  });
});
