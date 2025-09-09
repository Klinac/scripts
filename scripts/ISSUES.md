# Bypass Hilton Anti-Bot Crypto Challenge for Login API (Force Payload)

## Problem
The Hilton login API (https://www.hilton.com/en/auth2/api/guest/login/OHW/) returns a 428 status and a JSON response with a cryptographic anti-bot challenge. The server expects a challenge to be solved (proof-of-work) before allowing further requests.

## What Needs to Be Done
- Analyze the challenge response, which includes parameters like chlge_content_url, token, nonce, difficulty, etc.
- Create a script or payload to:
    1. Request the `chlge_content_url` to understand the expected work.
    2. Solve the crypto challenge (proof-of-work or similar, as specified by the provider: 'crypto').
    3. Submit the solution to `verify_url`.
    4. Use the validated session/cookie/token to attempt the login again.
    5. Automate this process so the login script can force and handle the payload challenge.

## Goal
Automate the bypass of the Hilton anti-bot challenge so that login requests can be made from a script.