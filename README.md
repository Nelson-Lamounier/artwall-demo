# 🌐 Static Web Application with AWS Serverless Contact Form

This repository contains a fully responsive, static marketing website developed using **HTML5**, **CSS3**, and **JavaScript**. It is designed to display a curated gallery of artwork and includes a fully functional contact form powered by **AWS Lambda** and **AWS SES**. The project demonstrates real-world experience in **frontend development** and **serverless architecture on AWS**.

---

## 🔗 Live Demo

🌍 **URL**: [Live Site](https://project2.lamounierdigital.com/)

---

## 🧰 Tech Stack

| Layer            | Technology                         |
|------------------|-------------------------------------|
| **Frontend**      | HTML5, CSS3, JavaScript             |
| **Email Backend** | AWS Lambda, AWS SES (serverless)    |
| **Hosting/CDN**   | AWS S3 (static hosting), CloudFront |

---

## 🎯 Key Features

- **Responsive Design**: Optimized for all screen sizes using semantic HTML and responsive CSS layout techniques.
- **Client-Side Interactivity**: Implemented smooth UI interactions using vanilla JavaScript (DOM manipulation, form validation).
- **Serverless Contact Form**: Form submissions are routed through **AWS Lambda**, triggering email notifications via **SES**.
- **Cloud-Based Hosting**: Static assets served globally via **S3 + CloudFront** for performance and scalability.
- **Secure & Maintainable**: No server provisioning; infrastructure is lightweight, secure, and cost-efficient.

---

## 🛠 Deployment Architecture

This project follows a **static frontend + serverless backend pattern**, ideal for simple content-based sites requiring form handling without full backend servers.

- **Frontend**: Built with HTML/CSS/JavaScript, bundled and deployed to **Amazon S3**.
- **CDN**: Cached and served via **Amazon CloudFront** for global latency reduction.
- **Form Handling**: Uses **AWS Lambda (Node.js)** to validate and forward form data.
- **Email Delivery**: Integrated with **AWS Simple Email Service (SES)** for message delivery.
- **Domain Management**: Configured through **Amazon Route 53**.

---

## 📁 Project Purpose

This project demonstrates:
- How to integrate **serverless backend logic** into static web applications.
- Applying **cloud-native deployment** patterns using AWS infrastructure.
- Practical use of **frontend fundamentals** alongside scalable backend components.

> This repository is for demonstration and portfolio purposes. All visual content has been anonymised for confidentiality.

---

## 📄 License & Notes

This repository is intended for educational and demonstration use only. Do not reuse or redistribute without permission.