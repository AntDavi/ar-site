// Menu hamburger acessível e simples
document.addEventListener("DOMContentLoaded", function () {
  const nav = document.getElementById("main-nav");
  const toggle = document.getElementById("navToggle");
  const header = document.querySelector(".header");

  if (!nav || !toggle) return;

  function openNav() {
    header.classList.add("nav-open");
    toggle.setAttribute("aria-expanded", "true");
    nav.setAttribute("aria-hidden", "false");
    // move focus to first link for keyboard users
    const firstLink = nav.querySelector("a");
    if (firstLink) firstLink.focus();
  }

  function closeNav() {
    header.classList.remove("nav-open");
    toggle.setAttribute("aria-expanded", "false");
    nav.setAttribute("aria-hidden", "true");
    toggle.focus();
  }

  toggle.addEventListener("click", function () {
    if (header.classList.contains("nav-open")) closeNav();
    else openNav();
  });

  // close when pressing Escape
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && header.classList.contains("nav-open")) {
      closeNav();
    }
  });

  // close when clicking outside nav on mobile
  document.addEventListener("click", function (e) {
    if (!header.classList.contains("nav-open")) return;
    if (!header.contains(e.target)) return;
    const insideNav = nav.contains(e.target) || toggle.contains(e.target);
    if (!insideNav) closeNav();
  });
});
