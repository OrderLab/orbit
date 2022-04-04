#include <curl/curl.h>
#include <assert.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

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

int main() {
	for (int i = 0; i < 1000 * 300; ++i) {
		if (i % 10)
			get_one();
			//put_one();
		else
			put_one();
		if ((i+1) % 1000 == 0)
			fprintf(stderr, "Finished %d\n", i + 1);
	}
}
