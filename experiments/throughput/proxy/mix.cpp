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

void get_one(const char *url) {
	CURLcode res;
	CURL *curl = curl_easy_init();
	assert(curl);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
	curl_easy_setopt(curl, CURLOPT_URL, url);
	res = curl_easy_perform(curl);
	curl_easy_cleanup(curl);
	(void)res;
}

void thd(void) {
	for (int i = 0; i < 1000 * 200; ++i) {
		const char *url = i % 10
			? "http://127.0.0.1:8080/index.html"
			: "http://127.0.0.1:8080/somepath/index.html?&ROUTEID=.fe02";
		get_one(url);
		if ((i+1) % 10000 == 0)
			std::cerr << "Finished " << (i + 1) << '\n';
	}
}

int main() {
	std::cerr << "Started running..." << std::endl;

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
