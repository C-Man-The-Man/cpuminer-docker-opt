# cpuminer-docker-opt

A lightweight, multi-architecture Docker build of **cpuminer-opt** with environment-driven configuration and optional CLI passthrough.

This project builds directly from the upstream [cpuminer-opt](https://github.com/JayDDee/cpuminer-opt) source and exposes a simple, portable runtime interface via Docker.

Supports **all algorithms** available in cpuminer-opt (sha256d, scrypt, x11, lyra2, argon2d, and many more).

### Features
- Easy fractional CPU targeting via `CPU_FRACTION`
  (automatically converts CPU share into an appropriate thread count, see the `.env` file)
- Environment-driven mode (perfect for docker-compose or any orchestrator)
- Full CLI passthrough mode for advanced users
- Automatic `wallet.worker` formatting for easy debugging
- Tiny, secure, non-root image
- Multi-arch support (linux/amd64 + linux/arm64)

For full algorithm list, tuning options, and miner documentation, see the [original cpuminer-opt repository](https://github.com/JayDDee/cpuminer-opt).

---

## Quick Start (one-liner)

```bash
docker run -d --name cpuminer \
  --cpus=0.25 \
  -e CPU_FRACTION=0.25 \
  -e POOL=stratum+tcp://your-pool:port \
  -e WALLET=your_wallet_address \
  -e WORKER=worker_name \
  -e ALGO=sha256d \
  ghcr.io/c-man-the-man/cpuminer-docker-opt:latest
```

#### Note:

- `CPU_FRACTION` controls how many CPU threads cpuminer will use.
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

Edit the `.env` file with your settings (example already included).

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
| `CPU_FRACTION` | Fraction of CPU cores used (e.g. 0.25 = 25%)     | 1.0     |
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
- cpuminer runs with a fixed number of threads (`-t`), which are then scheduled by the OS within the CPU limits defined by Docker
- Increasing `CPU_FRACTION` increases parallelism; decreasing it reduces resource usage and power consumption.

---
  
## License

This Docker image is provided under the same terms as cpuminer-opt.
See the [original license](https://github.com/JayDDee/cpuminer-opt/blob/master/COPYING).

---

## Enjoy simple, portable, and efficient CPU mining!

---

## Donations

**Bitcoin wallet address**
```text
bc1qt9qpxmf0lu00dz8ff92wtpz5jc5tmtxewj7h83
```

**Litecoin wallet address**
```text
ltc1q9d384fqzjcuy9a46d258exa8zqc70lma2ufd0n
```

**Dogecoin wallet address**
```text
DTKb6X1im7p5xVi4w3rBWCqoSL2eLrGiDG
```

**EVM / Metamask  (ETH, ETC, OCTA, POL, USDT, USDC, DATA etc.)**
```text
0x29d5d76F0555605878Ea112fEdcD859d825f45C2
```

**Solana wallet address**
```text
F5VVkpFoh1nccBu62mnviNxDQBVd9QQ16yLTXrBoVpdw
```

**Kadena wallet address**
```text
k:174f94ba7aa54eca1515f87b0f5deb1725cad6f7116f2277885e45af53908ae5
```

Thank you!
