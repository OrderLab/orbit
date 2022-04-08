#include <curl/curl.h>
#include <cassert>
#include <thread>
#include <chrono>
#include <iostream>

using std::chrono::high_resolution_clock;

size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata) {
	(void)ptr;
	(void)size;
	(void)userdata;
	return nmemb;
}

void get_one() {
	CURLcode res;
	CURL *curl = curl_easy_init();
	assert(curl);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
	curl_easy_setopt(curl, CURLOPT_URL, "http://127.0.0.1/");
	res = curl_easy_perform(curl);
	curl_easy_cleanup(curl);
	(void)res;
}

// curl -X PUT -d 'hello' localhost/dd/a.txt
// https://stackoverflow.com/a/7570281
void put_one() {
	CURLcode res;
	CURL *curl = curl_easy_init();
	assert(curl);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
	curl_easy_setopt(curl, CURLOPT_URL, "http://127.0.0.1/dd/a.txt");
	curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT");
	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "hello\n");
	res = curl_easy_perform(curl);
	curl_easy_cleanup(curl);
	(void)res;
}

void thd(void) {
	for (int i = 0; i < 1000 * 300; ++i) {
		if (i % 10)
			get_one();
		else
			put_one();
		if ((i+1) % 10000 == 0)
			std::cerr << "Finished " << (i + 1) << '\n';
	}
}

int main() {
	std::cerr << "Start running..." << std::endl;

	auto start = high_resolution_clock::now();

	std::thread t1(thd);
	std::thread t2(thd);
	std::thread t3(thd);
	std::thread t4(thd);

	t1.join();
	t2.join();
	t3.join();
	t4.join();

	auto end = high_resolution_clock::now();

	std::cerr << "Finished running." << std::endl;
	std::cout << (end - start).count() << std::endl;

	return 0;
}
