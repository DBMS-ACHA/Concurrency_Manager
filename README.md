# High-Concurrency Transactional Engine with 2PL and Retry Logic

This project implements a robust concurrency control system in **C++**, using the **Two-Phase Locking (2PL)** protocol with **retry-until-success**, **randomized exponential backoff**, and **thread-level parallelism**. It ensures serializability and high throughput under contention.

## Table of Contents
- [Overview](#overview)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Implementation Highlights](#implementation-highlights)
- [Build & Run](#build--run)
- [Test Cases](#test-cases)
- [References](#references)

---

## Overview

This system simulates high-contention environments where hundreds of threads perform conflicting operations concurrently. Transactions retry upon conflict, and a backoff mechanism limits CPU waste and livelock.

Key stats:
- **Up to 1000+ threads**
- **6x throughput** compared to serial execution
- **6 retries per transaction (avg. cap)**
- **100% commit success** under stress

---

## Key Features

- ✅ **2PL with Growing/Shrinking Phase Enforcement**
- 🔁 **Retry-Until-Success** with per-transaction retry tracking
- ⏱️ **Randomized Exponential Backoff** to mitigate contention
- 🔒 **Thread-Safe Locks with C++ Mutexes and Condition Variables**
- 🔍 **Deadlock Detection Module**
- 📊 **Performance Heatmaps and Logs**

---

## Architecture

### Core Modules

- `LockManager` — Manages shared/exclusive locks with queues and notifies waiting threads.
- `Transaction` — Represents each transaction and its state machine.
- `ConcurrencyManager` — Orchestrates transaction execution, lock handling, and retries.
- `DeadlockDetector` — (Optional) Scans wait-for graphs for cycles.
- `Logger` — Multi-threaded logger for debugging and benchmarking.

---

## Implementation Highlights

### 🔒 Lock Management
- Fine-grained resource locking using `std::mutex` and `std::condition_variable`
- Wait until lock granted or transaction aborted

### 🔁 Retry & Backoff Strategy
- Retry loop on transaction failure due to contention
- **Randomized exponential backoff**:
  ```cpp
  std::this_thread::sleep_for(std::chrono::microseconds(rand() % (1 << retry_count))); 
  ```
- Priority-based transaction restart to prevent starvation
- Automatic incremental priority increase after each retry
- Jitter added to backoff times to prevent thundering herd problem

### 📊 Deadlock Detection 
- Wait-for graph construction and cycle detection
- Priority-based victim selection for deadlock resolution
- Victim transactions automatically restarted with higher priority
- Configurable deadlock detection interval

### 📝 Logging & Metrics
- Detailed transaction metrics logging
- Resource allocation graph visualization
- Performance statistics (throughput, latency, success rate)
- Per-transaction retry tracking and lock acquisition statistics

---

## Build & Run

### Prerequisites
- C++23 compatible compiler (GCC 8+ or Clang 7+)
- pthread support

### Building the Project
```bash
make deadlock_test_runner
make single_thread_test_runner
```

### Running Tests
```bash
# Run a basic deadlock detection test
./deadlock_test_runner tests/test.txt

# Run on single thread 1000 transactions
./single_thread_test tests/test.txt

# Run single thread for high contention
./single_thread_test tests/dead_test.txt

# Run a high-concurrency test with 1000 transactions
./deadlock_test_runner tests/dead_test.txt
```

---

## Test Cases

- The system uses a text-based DSL (Domain Specific Language) for defining transaction scenarios

```
START T1
R1(A)
W1(B)
C1

START T2
R2(B)
W2(A)
C2
```

Each line represents an operation:

- START Tx - Begin transaction x
- Rx(item) - Read operation by transaction x on item 
- Wx(item) - Write operation by transaction x on item
- Cx - Commit transaction x
- Ax - Abort transaction x
- RELEASE Tx(item) - Explicit lock release

Generate test cases by following: 

```bash
# Less contention
python3 generate_simple.py

#High contention
python3 generate_diff.py
```

---

## References

1. Bernstein, P. A., & Goodman, N. (1981). "Concurrency Control in Distributed Database Systems". *ACM Computing Surveys*.

2. Gray, J., & Reuter, A. (1992). "Transaction Processing: Concepts and Techniques". *Morgan Kaufmann*.

3. Silberschatz, A., Korth, H. F., & Sudarshan, S. (2010). "Database System Concepts". *McGraw-Hill Education*.

4. Herlihy, M., & Shavit, N. (2012). "The Art of Multiprocessor Programming". *Morgan Kaufmann*.

5. Tannenbaum, A. S. (2007). "Modern Operating Systems". *Pearson*.

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.