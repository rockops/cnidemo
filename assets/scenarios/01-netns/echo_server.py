#!/usr/bin/env python3
"""
Simple echo server that listens on all interfaces (0.0.0.0).
Used to demonstrate network namespace isolation and connectivity.
Supports:
  - HTTP GET: echoes the URL path (e.g., /Hello -> "Hello")
  - HTTP POST: echoes the request body
  - Raw TCP: echoes back received bytes
"""
import os
import signal
import socket
import sys

def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    host = sys.argv[2] if len(sys.argv) > 2 else '0.0.0.0'

    # Handle termination cleanly
    signal.signal(signal.SIGTERM, lambda s, f: sys.exit(0))

    server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        server_sock.bind((host, port))
        server_sock.listen(5)
    except Exception as err:
        print(f"Error binding to {host}:{port}: {err}", file=sys.stderr)
        sys.exit(1)

    print(f"📡 Echo server listening on {host}:{port} (PID: {os.getpid()})")
    sys.stdout.flush()

    while True:
        try:
            conn, addr = server_sock.accept()
        except (KeyboardInterrupt, SystemExit):
            break
        except Exception:
            continue

        with conn:
            try:
                data = conn.recv(4096)
                if not data:
                    continue

                if data.startswith(b"GET ") or data.startswith(b"POST "):
                    lines = data.split(b"\r\n")
                    first_line = lines[0].decode(errors='ignore')
                    if first_line.startswith("GET "):
                        path = first_line.split()[1].lstrip('/')
                        msg = path if path else "Echo from namespace ns1"
                        body = f"{msg}\n".encode()
                    else:
                        parts = data.split(b"\r\n\r\n", 1)
                        body = parts[1] if len(parts) > 1 and parts[1] else b"Echo from namespace ns1\n"

                    resp = (
                        b"HTTP/1.1 200 OK\r\n"
                        b"Content-Type: text/plain\r\n"
                        b"Content-Length: " + str(len(body)).encode() + b"\r\n"
                        b"Connection: close\r\n\r\n" + body
                    )
                    conn.sendall(resp)
                    print(f"📥 Received HTTP: {first_line.strip()} -> Sent echo: {body.decode(errors='ignore').strip()}")
                else:
                    conn.sendall(data)
                    print(f"📥 Received TCP: {data.decode(errors='ignore').strip()} -> Echoed back")
                sys.stdout.flush()
            except Exception:
                pass

if __name__ == '__main__':
    main()
