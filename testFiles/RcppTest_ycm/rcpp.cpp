#include <Rcpp.h>
using namespace std;
using namespace Rcpp;

//NOTE
//library("Rcpp")
//sourceCpp("J:/CUmansky/R/tests/rcpp.cpp")

//[[Rcpp::export]]
List testNA(DataFrame df){
	const int N = df.nrows();
	//Test for NA in an IntegerVector
	IntegerVector intV = df["intV"];
	//1: ca marche
	LogicalVector resInt = is_na(intV); 
	//2: ca marche aussi comme ca
	//for(int i=0; i<df.nrows(); i++){
		//resX[i] = IntegerVector::is_na(x[i]) ? true : false; }
	
	//Test for NA in an CharacterVector
	CharacterVector strV = df["strV"];
	LogicalVector resStr = is_na(strV);

	//Test for NA in an DatetimeVector
	DatetimeVector dtV = df["dtV"];
	LogicalVector resDT(N, false);
	for(int i = 0; i < N; ++i){
		resDT[i] = NumericVector::is_na(dtV[i].getFractionalTimestamp());
	}
	return(List::create(_["df"]=df, 
						_["resInt"]=resInt,
						_["resStr"]=resStr,
						_["resDT"]=resDT));

}
/*** R
cat("testing for NA\n")
intV <- c(1,NA,2)
df <- data.frame(intV=intV, strV=as.character(intV), dtV=as.POSIXct(intV,origin='1970-01-01'))
str(df)
testNA(df)
*/

//=======================================================================================
// Cette fonction sera compilée mais pas exportée, pas de problème pour l'utiliser
int add(int a, int b){
	return(a+b);
}
// [[Rcpp::export]]
int testNoExport(int a, int b){
	return(add(a,b));
}
/*** R
cat("testing for non-export\n")
a <- 1L; b <- 2L;
testNoExport(a,b)
*/

//=======================================================================================
//[[Rcpp::export]]
List testDatetimeVector(DatetimeVector dt){
	DatetimeVector a = dt;
	//NOTE: this crashes with Rcpp <= 0.10.3
	//      if underlying double is less than what you take from it => R crashes
	a[0] = dt[0]-2.1; 
	DatetimeVector b = dt;
	b[0] = dt[0]+2.1;
	double delta;
	delta = b[0]-a[0];
	LogicalVector f(5);
	f[0] = (b[0]-a[0])>4.3;
	f[1] = (b[0]-a[0])<=4.2;
	//DatetimeVector c = dt;
	//2013-07-17 Il n'y a pas de sugar pour DatetimeVector
	//c = dt + 1.123;
	return(List::create(_["dt"]=dt,
						_["dt[0]-2.1"]=a,
						_["dt[0]+2.1"]=b,
						//_["c"]=c,
						_["f"]=f,
						_["b[0]-a[0]"]=delta
					   ));
}
/*** R
cat("testing for datetime arithmetics\n")
dt <- as.POSIXct(c(1374249654,1374249659), origin='1970-01-01')
testDatetimeVector(dt)
*/

//=======================================================================================
// [[Rcpp::export]]
List listFunction(){

	int nbElem = 5;
	List l(nbElem);
	l[0] = 3;
	l[1] = "5";	
	IntegerVector v(5, NA_INTEGER);
	NumericVector u(5, .5);
	for(int i=2; i<5; ++i){
		l[i] = u;
	}
	//l[3][2] = .25; THIS DOES NOT COMPILE !!
	return l;
}

//=======================================================================================
// [[Rcpp::export]]
List strFunction(CharacterVector x, CharacterVector y){
	
	CharacterVector xm = x; //assignement operator
	vector<string> x2 = as<vector<string> >(x), y2 = as<vector<string> >(y); //casting with as
	
	int N = x.size();
	LogicalVector r(N),r2(N),r3(N),r4(N);
	for(int i=0; i<N; i++){
		r[i] = (x[i] == "hello") ? true : false;
		//r2[i] = (x[i] == y[i]) ? true : false;
		r3[i] = ((*(char*)x[i] == *(char*)y[i])); //does not seem to work
		r4[i] = x2[i] == y2[i]; //does seem to work (thanks STL)
	}
	return List::create(_["x"] = x,
						_["y"] = y,
                        _["x==hello"] = r,
						//_["x==y"] = r2,
						_["cast"] = r3,
						_["x2==y2"] = r4);
}

//=======================================================================================
// [[Rcpp::export]]
vector<string> strFunction2(vector<string> strVec){
	/*
	INPUT: df: table des ordres
	USAGE: 
	*/
	const int N = strVec.size();  
	vector<string> out=strVec;

	for(int i=1; i<N; i++){
		out[i] = strVec[i].erase(0,3);
	}
	return(out);
}

/*
// [[Rcpp::export]]
map<double, string> foo() {
	map<double, string> s;
	s[3.14] = "quick";
	s[2.22] = "brown";
	s[1.11] = "fox";
	return s;
}

// [[Rcpp::export]]
List useDatetime(Datetime dt){
	Datetime dt2(dt); //constructor from SEXP
	Datetime dt3("2011-01-01 08:00:00"); //constructor from std::string
	double fracDateTime = dt.getFractionalTimestamp(); //this is frac sec since eopch
	Datetime dt4 = dt + (-.1); //attention operateur + pour double
	return(List::create(_["input"] = dt,
						_["constructorSEXP"] = dt2,
						_["constructorString"] = dt3,
						_["getFractionalTimestamp"] = fracDateTime,
						_["+operator"] = dt4));
}

//[[Rcpp::export]]
Datetime foo(Datetime dt){
	return(dt);
}

//[[Rcpp::export]]
void testPrint(vector<string> x, string pattern){
	const int N = x.size();
	for(int i=0; i<N; i++){
		if (std::regex_match (x[i], std::regex(pattern) ))
			Rcout << "string " << x[i] << " matched" << endl;
	}
}
*/
