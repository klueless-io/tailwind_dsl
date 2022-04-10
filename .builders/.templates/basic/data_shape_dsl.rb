def action

{{#each components}}
  # {{titleize ./component_name}}
  DataShape
    .init(:{{./component_name}})
    .data do
{{dsl_content}}
      image                 "https://images.unsplash.com/photo-1606660265514-358ebbadc80d?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1575&q=80"
      brand                 "Brand"
      welcome_back_message  "Welcome Back"
      google_label          "Sign in with Google"
      alternate_label       "or login with email"
      email_label           "Email Address"
      password_label        "Password"
      forgot_password_label "Forget Password?"
      submit_label          "Login"
      signup_label          "or sign up"
    end

{{/each}}
end

