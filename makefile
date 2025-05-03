run: deadlock_test_runner
	./deadlock_test tests/test.txt

deadlock_test_runner: tests/test_deadlock_detection.cpp src/concurrency_manager.cpp src/lock_manager.cpp src/deadlock_detector.cpp src/transaction.cpp src/logger.cpp src/resource_manager.cpp
	g++ -std=c++23 -o deadlock_test tests/test_deadlock_detection.cpp src/concurrency_manager.cpp src/lock_manager.cpp src/deadlock_detector.cpp src/transaction.cpp src/logger.cpp src/resource_manager.cpp -pthread

runsingle: single_thread_test
	./single_thread_test tests/test.txt

single_thread_test_runner: tests/single_thread.cpp src/concurrency_manager.cpp src/lock_manager.cpp src/deadlock_detector.cpp src/transaction.cpp src/logger.cpp src/resource_manager.cpp
	g++ -std=c++23 -o single_thread_test tests/single_thread.cpp src/concurrency_manager.cpp src/lock_manager.cpp src/deadlock_detector.cpp src/transaction.cpp src/logger.cpp src/resource_manager.cpp -pthread

clean:
	rm -f deadlock_test* 
	rm -f *.log
