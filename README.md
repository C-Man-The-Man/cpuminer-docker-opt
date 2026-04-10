# cpuminer-docker-opt

A lightweight, multi-architecture Docker build of **cpuminer-opt** with environment-driven configuration and optional CLI passthrough.

This project builds directly from the upstream [cpuminer-opt](https://github.com/JayDDee/cpuminer-opt) source and exposes a simple, portable runtime interface via Docker.

Supports **all algorithms** available in **cpuminer-opt** (sha256d, scrypt, x11, lyra2, argon2d, and many more).

### Features
- Easy fractional CPU targeting via `CPU_FRACTION`
  (automatically converts CPU share into an appropriate thread count, see the `.env` file)
- Environment-driven mode (perfect for docker-compose or any orchestrator)
- Full CLI passthrough mode for advanced users
- Automatic `wallet.worker` formatting for easy debugging
- Tiny, secure, non-root image
- **Multi-arch support (linux/amd64 + linux/arm64)**

For full algorithm list, tuning options, and miner documentation, see the [original cpuminer-opt repository](https://github.com/JayDDee/cpuminer-opt).

---

## Quick Start (one-liner)

```bash
docker run -d --name cpuminer \
  --cpus=0.25 \
  -e CPU_FRACTION=0.25 \
  -e POOL=stratum+tcp://pool:port \
  -e PASSWORD=x \
  -e WALLET=wallet_address \
  -e WORKER=worker_name \
  -e ALGO=sha256d \
  ghcr.io/c-man-the-man/cpuminer-docker-opt:latest
```

#### Note:

- `CPU_FRACTION` controls how many CPU threads **cpuminer** will use.
- `--cpus` is a Docker-level limit that controls how much CPU time the container is allowed to consume.
- For best results, keep `CPU_FRACTION` and `--cpus` aligned.

You may omit `CPU_FRACTION` if you prefer Docker to control CPU usage via `--cpus`.

---

## Advanced Setup (recommended – docker-compose + .env)

Clone the repository:

```bash
git clone https://github.com/C-Man-The-Man/cpuminer-docker-opt.git
cd cpuminer-docker-opt
```

Edit the `.env` file with your settings (examples already included).

Start the miner:

```bash
docker compose up -d
```

View logs:

```bash
docker compose logs -f
```

Stop and remove:
```bash
docker compose down
```

---

## Building from Source

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/c-man-the-man/cpuminer-docker-opt:latest --push .
```

---

## Environment variables

| Variable       | Description                                      | Default |
|----------------|--------------------------------------------------|---------|
| `CPU_FRACTION` | **Fraction of CPU cores** used (e.g. 0.25 = 25%) | 1.0     |
| `POOL`         | Stratum pool URL                                 | required|
| `WALLET`       | Your wallet address                              | required|
| `WORKER`       | Worker name                                      | optional|
| `PASSWORD`     | Pool password                                    | x (generic)|
| `ALGO`         | Mining algorithm                                 | [complete list](https://github.com/JayDDee/cpuminer-opt/tree/master/algo)|
| `EXTRA_FLAGS`  | Any extra cpuminer-opt flags                     | optional|

---

## CPU behavior notes

- `CPU_FRACTION` is converted internally into a thread count:
    - Threads = CPU_FRACTION × available CPU cores
    - The result is rounded to the nearest whole number (minimum 1 thread)
- **cpuminer** runs with a fixed number of threads (`-t`), which are then scheduled by the OS within the CPU limits defined by Docker
- Increasing `CPU_FRACTION` increases parallelism; decreasing it reduces resource usage and power consumption.

---
  
## License

This Docker image is provided under the same terms as **cpuminer-opt**.
See the [original license](https://github.com/JayDDee/cpuminer-opt/blob/master/COPYING).

---

## Enjoy simple, portable, and efficient CPU mining!

---

## Donations

**Bitcoin wallet address**
```text
bc1qpcfex53u7mqx4dc25gw7j7446amw9vn6743cn5
```

**EVM / Metamask  (ETH, ETC, OCTA, POL, PEAQ, MONAD, BASE etc.)**
```text
0xbE4879888d95B02B2FCaed2FcAeBbcf36829BDC9
```

**Solana wallet address**
```text
7EHWvShXfjLJ2HhzTf4CsHgjKckivfMQMjnEoUAEqau
```

**Sui wallet address**
```text
0x421a5a462f99c2d675d035d0c741ba5765a47c1e28f95d33ad770cd34a36a6ea
```

**Thank you!**
