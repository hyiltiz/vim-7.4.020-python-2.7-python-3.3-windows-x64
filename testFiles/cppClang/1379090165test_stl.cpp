#include <vector>
#include <iterator>
#include <iostream>

int main()
{
	std::vector<int> vec;   // declare a vector of int

	vec.push_back(10);      // add some values
	vec.push_back(20);
	vec.push_back(30);
	vec.
	//"here type vec." and see it working
	std::copy(vec.begin(), vec.end(), std::ostream_iterator<int>(std::cout, " "));
	std::cout << std::endl;
}
