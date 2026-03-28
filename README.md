# cpuminer-docker-opt

A lightweight, multi-architecture Docker build of **cpuminer-opt** with environment-driven configuration and optional CLI passthrough.

This project builds directly from the upstream [cpuminer-opt](https://github.com/JayDDee/cpuminer-opt) source and exposes a simple, portable runtime interface via Docker.

Supports **all algorithms** available in cpuminer-opt (sha256d, scrypt, x11, lyra2, argon2d, and many more).

### Features
- Easy fractional CPU targeting with the `--cpu` flag (`CPU_FRACTION` environment variable)
- Environment-driven mode (perfect for docker-compose or any orchestrator)
- Full CLI passthrough mode for advanced users
- Automatic `wallet.worker` formatting for easy debugging
- Tiny, secure, non-root image
- Multi-arch support (linux/amd64 + linux/arm64)

For full algorithm list, tuning options, and miner documentation, see the [original cpuminer-opt repository](https://github.com/JayDDee/cpuminer-opt).

### Quick Start (one-liner)

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

Replace the placeholder values with your own pool, wallet, and worker name.
You can also use Docker’s native CPU limit without setting CPU_FRACTION — the entrypoint automatically matches the thread count.

### Advanced Setup (recommended – docker-compose + .env)

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

### Environment variables

**Variable**            **Description**                             **Default**

`CPU_FRACTION`          Fraction of CPU to use (0.25 = 25%)         1.0
`POOL`                  Stratum pool URL                            (required)
`WALLET`                Your wallet address                         (required)
`WORKER`                Worker name (appended as wallet.worker)     (optional)
`PASSWORD`              Pool password                               x (generic)
`ALGO`                  Mining algorithm                            [complete list](https://github.com/JayDDee/cpuminer-opt/tree/master/algo)
`EXTRA_FLAGS`           Any extra cpuminer-opt flags                (empty)

### Building from Source

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/c-man-the-man/cpuminer-docker-opt:latest --push .
```
  
## License

This Docker image is provided under the same terms as cpuminer-opt.
See the [original license](https://github.com/JayDDee/cpuminer-opt/blob/master/COPYING).

### Enjoy simple, portable, and efficient CPU mining!
