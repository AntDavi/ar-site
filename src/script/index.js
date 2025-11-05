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

  // Close nav when clicking on nav links
  const navLinks = nav.querySelectorAll("a");
  navLinks.forEach((link) => {
    link.addEventListener("click", function () {
      if (header.classList.contains("nav-open")) {
        closeNav();
      }
    });
  });

  // Smooth scroll for anchor links
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute("href"));
      if (target) {
        const headerHeight = header.offsetHeight;
        const targetPosition = target.offsetTop - headerHeight;
        window.scrollTo({
          top: targetPosition,
          behavior: "smooth",
        });
      }
    });
  });

  // Add scrolled class to header on scroll
  let lastScroll = 0;
  window.addEventListener("scroll", function () {
    const currentScroll = window.pageYOffset;

    if (currentScroll > 50) {
      header.classList.add("scrolled");
    } else {
      header.classList.remove("scrolled");
    }

    lastScroll = currentScroll;
  });

  // Form submission handler
  const form = document.querySelector(".footer-form");
  if (form) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      const emailInput = form.querySelector(".email-input");
      const email = emailInput.value;

      if (email && email.includes("@")) {
        // Add success feedback
        const button = form.querySelector(".submit-btn");
        const originalText = button.textContent;
        button.textContent = "ENVIADO!";
        button.style.background = "#4CAF50";
        button.style.color = "white";

        setTimeout(() => {
          button.textContent = originalText;
          button.style.background = "";
          button.style.color = "";
          emailInput.value = "";
        }, 2000);
      }
    });
  }

  // Intersection Observer for fade-in animations
  const observerOptions = {
    threshold: 0.1,
    rootMargin: "0px 0px -50px 0px",
  };

  const observer = new IntersectionObserver(function (entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = "1";
        entry.target.style.transform = "translateY(0)";
      }
    });
  }, observerOptions);

  // Observe sections for animations
  const sections = document.querySelectorAll(
    ".solucao-card, .processo-item, .incluso-card, .orcamento-item"
  );
  sections.forEach((section) => {
    section.style.opacity = "0";
    section.style.transform = "translateY(20px)";
    section.style.transition = "opacity 0.6s ease, transform 0.6s ease";
    observer.observe(section);
  });
});
