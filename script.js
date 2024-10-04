window.onload = () => {
  setTimeout(() => {
    document.querySelector("body").classList.add("display");
  }, 4000);
};

document.querySelector(".hamburger-menu").addEventListener("click", () => {
  document.querySelector(".container").classList.toggle("change");
});

document.querySelector(".scroll-btn").addEventListener("click", () => {
  document.querySelector("html").style.scrollBehavior = "smooth";
  setTimeout(() => {
    document.querySelector("html").style.scrollBehavior = "unset";
  }, 1000);
});

const panels = document.querySelectorAll(".panel");

panels.forEach((panel) => {
  panel.addEventListener("click", () => {
    removeActiveClasses();
    panel.classList.add("active");
  });
});

function removeActiveClasses() {
  panels.forEach((panel) => {
    panel.classList.remove("active");
  });
}

// Form field effect //

document.querySelectorAll(".field").forEach((field) => {
  field.addEventListener("focus", () => {
    field.nextElementSibling.style.cssText =
      "transform: translateY(-3rem); font-size: 1.2rem;";
    field.style.borderBottomStyle = "solid";
  });

  field.addEventListener("focusout", () => {
    if (!field.value) {
      field.nextElementSibling.style.cssText =
        "transform: translateY(0); font-size: 1.6rem;";
      field.style.borderBottomStyle = "dashed";
    } else {
      field.nextElementSibling.style.cssText =
        "transform: translateY(-3rem); font-size: 1.2rem;";
      field.style.borderBottomStyle = "solid";
    }
  });
});

// Function to handle the form data //

const form = document.querySelector("form");
let modal = document.querySelector(".modal");
let trigger = document.querySelector(".submit-btn");
let closeButton = document.querySelector(".close-btn");
form.addEventListener("submit", (event) => {
  // prevent the form submit from refreshing the page
  event.preventDefault();

  const { name, phone, email, message } = event.target;
  // Use the API endpoint URL
  const endpoint =
    "https://47ury86d28.execute-api.eu-west-1.amazonaws.com/default/myWebsiteFormCo";

  // We use JSON.stringify here so the data can be sent as a string via HTTP
  const body = JSON.stringify({
    senderName: name.value,
    senderPhone: phone.value,
    senderEmail: email.value,
    message: message.value,
  });
  const requestOptions = {
    method: "POST",
    body,
  };

  fetch(endpoint, requestOptions)
    .then((response) => {
      if (!response.ok) throw new Error("Error in fetch");
      return response.json();
    })
    .then((response) => {
      document.getElementById("result-text").innerText =
        "Email sent successfully!";
      resetForm();
    })
    .catch((error) => {
      document.getElementById("result-text").innerText =
        "An unkown error occured.";
      resetForm();
    });
});
function resetForm() {
  $("#form")[0].reset();
}
