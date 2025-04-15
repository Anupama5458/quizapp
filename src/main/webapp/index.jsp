<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Quizzy!</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <!--Left Section-->
        <div class="left">
            <h1 class="fade-in">Welcome to <span>Quizzy!</span></h1>
            <p class="fade-in">Test your Knowledge. Anytime, Anywhere.</p>
        </div>

        <!--Right Section-->
        <div class="right">
            <div class="form-box slide-in">
                <div class="company-logo">
                    <img src="images/yash_tech1.png" alt="Company Logo">
                </div>

                <%
                // Check if register parameter is present
                String formType = request.getParameter("form");
                boolean isRegisterForm = "register".equals(formType);
                %>

                <% if (isRegisterForm) { %>
                    <!-- Registration Form -->
                    <h2>Register Here</h2>
                    <form action="RegisterServlet" method="post">
                        <div class="form-group">
                            <label>Enter your email: </label>
                            <input type="email" name="email" placeholder="Email ID" required>
                        </div>
                        <div class="form-group">
                            <label>Enter username: </label>
                            <input type="text" name="username" placeholder="Username" required>
                        </div>
                        <div class="form-group">
                            <label>Enter password:</label>
                            <input type="password" name="passkey" placeholder="Passkey" required>
                        </div>
                        <div class="btn-group">
                            <button type="submit" class="btn register">Register</button>
                        </div>
                    </form>
                    <p>Already registered? <a href="index.jsp">Login here</a></p>
                <% } else { %>
                    <!-- Login Form -->
                    <h2>Login or Register</h2>
                    <form action="LoginServlet" method="post">
                        <div class="form-group">
                            <label>Enter your email: </label>
                            <input type="email" name="email" placeholder="Email ID" required>
                        </div>
                        <div class="form-group">
                            <label>Enter username: </label>
                            <input type="text" name="username" placeholder="Username" required>
                        </div>
                        <div class="form-group">
                            <label>Enter password:</label>
                            <input type="password" name="passkey" placeholder="Passkey" required>
                        </div>
                        <div class="btn-group">
                            <button type="submit" class="btn register">Login</button>
                        </div>
                    </form>
                    <p>New User? <a href="index.jsp?form=register">Register here</a></p>
                <% } %>
            </div>
        </div>

        <!-- Message Container -->
        <div class="message-container">
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            <% if(request.getAttribute("message") != null) { %>
                <div class="success-message">
                    <%= request.getAttribute("message") %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>