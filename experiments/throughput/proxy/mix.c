#include <curl/curl.h>
#include <assert.h>

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

int main() {
	for (int i = 0; i < 1000 * 200; ++i) {
		const char *url = i % 10
			? "http://127.0.0.1:8080/index.html"
			// : "http://127.0.0.1:8080/somepath/index.html?ROUTEID=.fe02";
			: "http://127.0.0.1:8080/somepath/index.html?&ROUTEID=.fe02";
		get_one(url);
		if ((i+1) % 1000 == 0)
			fprintf(stderr, "Finished %d\n", i + 1);
	}
}
