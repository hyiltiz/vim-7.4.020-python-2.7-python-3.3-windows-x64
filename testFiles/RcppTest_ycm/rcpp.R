library(Rcpp)
library(inline)

#--------------------------------------------------------------------------
#Q> Pass numeric and vector of numeric
#Q> Pass string and vector of string
#Q> How to compare/modify 2 vector of strings 
#Q> How to use STL and include namespaces
#Q> How to deal with dates
# -pass POSIXct 
# -get sec since epoc 
# -substract number of seconds
#Q> How to deal vector of POSIXct
#Q>How to return a list 
#Q>How to use a matrix
#Q> How to modify data.table 
#----------------------------------------------------------------------------

#Q> Pass numeric and vector of numeric
#A>
cCode <- 
	'
	NumericVector s(s_);
	double s2 = as<double>(s_);
	NumericVector v(v_);
	
	return List::create(_["scalar"] = s[0],
						_["scalar2"] = s2,
						_["vector"] = v);
	';
numRet <- cxxfunction(signature(s_="numeric", v_="numeric"), plugin="Rcpp", body=cCode)
#T> 
numRet(3.45, c(1.,3.234))

#Q> Pass string and vector of string
#A>
cCode <- 
	'
	CharacterVector s(s_);
	string s2 = as<string>(s_);
	CharacterVector v(v_);
	
	return List::create(_["CHARSXP"] = s[0],
						_["string"] = s2,
						_["vecString"] = v);
	';
strRet <- cxxfunction(signature(s_="Character", v_="Character"), includes='using namespace std;', plugin="Rcpp", body=cCode)
#T> 
strRet("seb", c("seb","christine","colin"))

strMod <- cxxfunction(signature(x_="character", y_="character"), includes='using namespace std;', plugin="Rcpp", body=cCode)
#T> 
strMod( c("seb","christelle","colin"), c("seb","christine","colin") )

#Q> How to use STL and include namespaces
#A>
cCode <- 
	'
	vector<string> cx = as<vector<string> >(x);
	int N = cx.size();
	LogicalVector r(N);
	for(int i=0; i<N; i++){
		r[i] = (cx[i] == "coucou");
	}
	return(r);
	';
cCharCompare <- cxxfunction(signature(x="character"), plugin="Rcpp", includes='using namespace std;', body=cCode)
#T>
cCharCompare(c("a","coucou","t est","coucou"))

#Q> How to deal with dates
# -pass POSIXct       # -deal with timezones 
# -get sec since epoc # -add/substract number of seconds
#A>
dt <- as.POSIXct("2011-02-23 13:23:54.000234",format="%Y-%m-%d %H:%M:%OS",tz="America/Montreal");
useDatetime(dt);


#cCode <- 
	#'
	#Datetime myDT(dt); //constructor from SEXP
	#myDT.attr("tzone") = "America/Montreal";
	#return(wrap(myDT));
	#';
#test <- cxxfunction(signature(dt="Datetime"), plugin="Rcpp", body=cCode)


#Q> How to deal vector of POSIXct
cCode <- 
	'
	DatetimeVector myDT(dt); //constructor from SEXP
	return(wrap(myDT));
	';
vectDateTime <- cxxfunction(signature(dt="Datetime"), plugin="Rcpp", body=cCode)
#T>
N <- 5; posixVect <- .POSIXct(10*runif(N)); vectDateTime(posixVect);

#Q>How to return a list 
#A>
cCode <- 
	'
	//NOTE:even for a single number we use a vector	
	Rcpp::CharacterVector xx(x);
	Rcpp::NumericVector yy(y);
	//NOTE: when a vector the operation is vectorized
	yy = yy+1;
    return Rcpp::List::create(Rcpp::Named("x") = xx, Rcpp::Named("y") = yy);
	';
returnList <- cxxfunction(signature(x="character", y="numeric"), plugin="Rcpp", body=cCode)
#T>
returnList(c("a","b"), c(1.23,1))
returnList("a", c(1,1.23))

#Q>Pass a matrix and update it
#A>
cCode <- '
	NumericMatrix mat(mat_);   // creates Rcpp matrix from SEXP
	const int nR = mat.nrow(), nC = mat.ncol();
    NumericMatrix mat2(nR,nC); //constructor filled with 0. 

	return List::create(_["result"]=mat,
						_["mat_constructed"]=mat2,
						_["nR"]=nR,
						_["nC"]=nC);
	';
useMatrix <- cxxfunction(signature(mat_="matrix"), plugin="Rcpp", body=cCode)
#T>
useMatrix(matrix(rnorm(12),nrow=3));

#Q> How to modify data.table 
#A>
cCode <- 
	'
	DataFrame DT(DTi);
	NumericVector x = DT["x"];
	int N = x.size();
	LogicalVector b(N);
	NumericVector d(N);
	for(int i=0; i<N; i++){
		b[i] = x[i]<=4;
		d[i] = x[i]+1.;
	}
	return Rcpp::List::create(Rcpp::Named("b") = b, Rcpp::Named("d") = d);
	';
modDataTable <- cxxfunction(signature(DTi="data.frame"), plugin="Rcpp", body=cCode)
#T>
DT <- data.table(x=1:9,y=sample(letters,9))
DT_add <- modDataTable(DT)
DT[, names(DT_add):=DT_add]

#Q> How to modify data.table with POSIXct, IDate, ITime
#A>
cCode <- 
	'
	DataFrame DT(DTi);
	DatetimeVector posix = DT["p"];
	IntegerVector idate = DT["d"];
	IntegerVector itime = DT["t"];
	int N = DT.nrows();
	DatetimeVector posixS(N);
	DatetimeVector posixMS(N);
	NumericVector nbS(nbSi);
	NumericVector nbMS(nbMSi);
	for(int i=0; i<N; i++){
		posixS[i] = posix[i] + nbS[0];
		posixMS[i] = posix[i] + nbMS[0]/1000;
		idate[i] = idate[i] + 1;
		itime[i] = itime[i] + 10;
	}
	return List::create(_["posix"] = posix,
						_["posixS"] = posixS, 
						_["posixMS"] = posixMS,
						_["nbS"] = nbS,
						_["idate"] = idate,
						_["itime"] = itime);
	';
N <- 5; posixVect <- .POSIXct(10*runif(N)); IDateVect <- as.IDate(posixVect); ITimeVect <- as.ITime(posixVect);
DT <- data.table(p=posixVect, d=IDateVect, t=ITimeVect)
modDataTableTime <- cxxfunction(signature(DTi="data.frame", nbSi="numeric", nbMSi="numeric"), plugin="Rcpp", body=cCode)
#T>
modDataTableTime(DT, 5.2, 5.1)

#Q> Return complex maps from C++ to R
#A>
cCode <- '
	//map<double,T> does not work
	//map<double,string> myMap;
    //myMap[10.01] = "A";
    //myMap[14.62] = "B";
    //myMap[16.33] = "C";
	
	//map<string,double> works
	//map<string,double> myMap;
    //myMap["a1"] = 3.45;
    //myMap["a2"] = 3.1;
    //myMap["a3"] = 12.32;

	//map<string,vector<double>> work
	double v_value[] = {1.1,2.4};
    vector<double> v(v_value, v_value + sizeof(v_value)/sizeof(double));
    map<string, vector<double> > myMap;
    myMap["a2"] = v;
    myMap["a1"] = v;
	
	return wrap(myMap);

	//list of stuff
	//double v_value[] = {1.1,2.4};
	//vector<double> v(v_value, v_value + sizeof(v_value)/sizeof(double));
	//list<vector<double> > l;
	//l.push_back(v);
	//l.push_back(v);
	//return wrap(l);
	';
mapRet <- cxxfunction(signature(), includes='using namespace std;', plugin="Rcpp", body=cCode)
#T> 
mapRet();

cCode <- '
	//double v_value[] = {1.1,2.4};
	//vector<double> v(v_value, v_value + sizeof(v_value)/sizeof(double));
	//NumericMatrix m(3,2);
	//return m;

	double v_value[] = {1.1,2.4,1.1,2.4,1.1,2.4};
	vector<double> v(v_value, v_value + sizeof(v_value)/sizeof(double));
	NumericMatrix m(3,2);
	m = v;
	return m;

	//for(int i=0; i<2; i++){
	//	m(i,_) = v;
	//}
	//MatrixRow<int> m2(3);
	//return m2;
	';
fillMat <- cxxfunction(signature(), includes='using namespace std;', plugin="Rcpp", body=cCode)
#T> 
fillMat();
