# SuperCollider

Sound synthesis in "Synthesis.scd", needs a MIDI input to work.
- server boot, MIDI connection, I/O HW setup and server reboot
- tools to check MIDI incoming messages "MIDIFunc.trace(true)" and "MIDIFunc.trace(false)"
- block of sound synthesis for the keyboard

Backing track loop in "Backing_track.scd".

Install "Hi-Fi Cable" by VB-Audio at https://vb-audio.com/Cable/index.htm#DownloadASIOBridge to connect SuperCollider to JUCE.
After installation, search for "ASIO bridge" to set lowest latency possible

![image](https://github.com/GiulianoDiLorenzo/Jacob-SuperCollier/assets/165284554/00d7de3b-1b37-4aae-bacb-ea3ed7848237)

and your OS sound settings to match the sample-rate of "Hi-Fi Cable" with your system (for both Input and Output Cable)

![image](https://github.com/GiulianoDiLorenzo/Jacob-SuperCollier/assets/165284554/84b896e9-1d3e-4bff-8382-d97561838032)

