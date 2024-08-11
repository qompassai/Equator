Install CMake and Git by opening PowerShell in Administrator Mode and running these commands:

```
winget install --id Git.Git -e --source winget
winget install --id Kitware.CMake -e --source winget
```

Cross-compile Ninja for aarch64-windows:

```
git clone https://github.com/ninja-build/ninja
cd ninja
git checkout v1.11.1
```

Apply this patch:

```diff
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 70fc5e9..8b90dad 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -5,15 +5,7 @@ include(CheckIPOSupported)
 
 project(ninja)
 
-# --- optional link-time optimization
-check_ipo_supported(RESULT lto_supported OUTPUT error)
-
-if(lto_supported)
-	message(STATUS "IPO / LTO enabled")
-	set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)
-else()
-	message(STATUS "IPO / LTO not supported: <${error}>")
-endif()
+set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE FALSE)
 
 # --- compiler flags
 if(MSVC)
```

```
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(pwd)/dist -DCMAKE_AR="$HOME/local/llvm15-release/bin/llvm-ar" -DCMAKE_CXX_COMPILER_AR="$HOME/local/llvm15-release/bin/llvm-ar" -DCMAKE_RANLIB="$HOME/local/llvm15-release/bin/llvm-ranlib" -DCMAKE_CXX_COMPILER_RANLIB="$HOME/local/llvm15-release/bin/llvm-ranlib" -DCMAKE_C_COMPILER_AR="$HOME/local/llvm15-release/bin/llvm-ar" -DCMAKE_C_COMPILER_RANLIB="$HOME/local/llvm15-release/bin/llvm-ranlib" -DCMAKE_CROSSCOMPILING=True -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_RC_COMPILER="$HOME/local/llvm15-release/bin/llvm-rc"
make install
```

This produces `dist/bin/ninja.exe` which you can send to your Windows machine with [WebWormhole](https://webwormhole.io/).

You must then put ninja.exe into one of the directories in the system-wide `Path` environment variable (or add a new directory to that environment variable if necessary). This is how CMake detects the existence of Ninja.

## Troubleshooting

Situation: aarch64-windows CI runners stop responding.

Probable cause:
1. A Windows Update caused the box to restart.
2. The Actions Runner service did not get automatically started on boot like it was supposed to.
3. GitHub puts the runner into some kind of zombie state where it is not deleted but also can't be started.

Steps to fix it:

1. Plug in a monitor and keyboard and see the screen that says "Let's finish setting up your PC."
2. There is no button that says "never do this", you have to click "finish later". This is to make sure you understand that Microsoft doesn't give a shit about what you want. This is Microsoft's computer, not yours.
3. Log in and do the windows update manually, because it still didn't even complete successfully on its own.
4. The system time is incorrect somehow. Go to Windows Time & Language control panel, toggle "Set time automatically" to OFF, then back to ON. System time becomes correct again.
5. Run powershell as an administrator.
   - Now you think that you can just restart the service. Think again. If you do, it will say "Failed to create a session because the registration has been deleted from the server. Please re-configure".
   - However, if you follow those instructions, it says "Cannot configure the runner because it is already configured. To reconfigure the runner, run 'config.cmd remove' first".
6. Ignore the unsolicited advertisement to install Copilot.
7. Run .\config.cmd remove and it asks for a runner remove token
8. Go to github and click Remove Runner, copy the token, and complete the remove command.
9. Go to github and click Add Runner and then use that token to run the .\config.cmd again. Go through the configuration again.
10. Repeat this process for the 2nd self-hosted runner instance on the same machine
