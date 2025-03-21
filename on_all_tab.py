import pyautogui
import subprocess
import time
import platform
import sys

def onall(command):
    '''
    Execute $command on all terminal tabs.
    This script will automatically identify the operating system, and work on different terminal applications.
    '''

    os_name = platform.system()

    if os_name == "Darwin":  # macOS
        try:
            # Return a string that containing all the windows_id of active terminal tabs.
            # 
            # Example: '829, 302, missing value, 747'
            #     829, 302, 747     windows_id of active terminal tabs.
            #     missing value     Can't get the windows_id. This terminal window/tab might be generated by an application, such as TERMINAL in VSCode.
            script = 'tell application "Terminal" to get id of every window'
            output = subprocess.check_output(["osascript", "-e", script]).decode().strip()

            if not output:
                return
            window_ids = [wid.strip() for wid in output.split(',')]

        except Exception as e:
            print("Got error when getting window_id: ", e)
            return

        for window_id in window_ids:
            try:
                if window_id and window_id != "missing value":
                    # Use "do script" of AppleScript to execute command.
                    script = f'tell application "Terminal" to do script "{command}" in window id {window_id}'
                    subprocess.run(['osascript', '-e', script])
                    
                    # Wait 0.5 second waiting for window activating and command sending to window.
                    time.sleep(0.5)
                else:
                    # If an window_id is not identified, skip the window/tab.
                    print("Skip an unidentified window/tab")
            except Exception as e:
                print(f"Got error on Terminal: {window_id} when executing command: {e}")

    elif os_name == "Linux":
        try:
            window_ids = subprocess.check_output(["xdotool", "search", "--class", "Terminal"]).decode().splitlines()
        except FileNotFoundError:
            print("Please install xdotool.")
            return

        for window_id in window_ids:
            try:
                subprocess.run(["xdotool", "windowactivate", window_id])
                time.sleep(0.5)
                pyautogui.typewrite(command + "\n")
                time.sleep(0.25)
            except Exception as e:
                print(f"Got error on Terminal: {window_id} when executing command: {e}")

    elif os_name == "Windows":
        import win32gui
        import win32con

        def window_enum_handler(hwnd, results):
            if win32gui.IsWindowVisible(hwnd):
                window_title = win32gui.GetWindowText(hwnd)
                if "命令提示字元" in window_title or "Windows PowerShell" in window_title:
                    results.append(hwnd)

        window_handles = []
        win32gui.EnumWindows(window_enum_handler, window_handles)

        for hwnd in window_handles:
            try:
                win32gui.ShowWindow(hwnd, win32con.SW_SHOWNORMAL)
                win32gui.SetForegroundWindow(hwnd)
                time.sleep(0.5)
                pyautogui.typewrite(command + "\n")
                time.sleep(0.25)
            except Exception as e:
                print(f"Got error on Terminal: {window_id} when executing command: {e}")

    else:
        print(f"Currenly, we don't support operating system: {os_name}")

if __name__ == "__main__":
    command = ' '.join(sys.argv[1:])
    onall(command)