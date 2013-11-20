#include <vector>
#include <iterator>
#include <iostream>
#include <algorithm>
#include <string>
#include <map>

int main()
{
	//1.Clang complete completion
	std::vector<int> vec(5);   // declare a vector of int
	//====> "here type vec." and see it working

	//2.Snippets
	//====> "here type for+TAB should trigger snipmate"
	for (int i = 0; i < vec.size(); i++) {
		//do something
	}
	
}
