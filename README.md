# file-integrity-monitoring
Final Project for H.Dip in Cybersecurity

Instructions:

1. Open in any compatible source code editor. The code was developed using PowerShell.
2. Users will be asked a question on what they intend to do. This was answerable by typing either ‘A’ or ‘B’

    "Hello. What would you like to do?"
    A. Create baseline hashes and save in secure folder?
    B. Monitor existing file/s for changes?
    
    Kindly input either 'A' or 'B'

3. When users type ‘A’, a separate folder containing baseline hashes will be created in the local host’s system based on specified path.
4. On the other hand, when ‘B’ is chosen and the system DOES NOT DETECT any changes, the application will be triggered to start then continuously loop in a specified folder. There will be no alert message on display.
5. Otherwise, if a CHANGE HAS BEEN DETECTED, the application will send out an alert to the user. Alert message varies depending on what the trigger was: a new file has been created, a file has been deleted, or a file has been edited/modified.
