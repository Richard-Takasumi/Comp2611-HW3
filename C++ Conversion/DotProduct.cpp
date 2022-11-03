#include <iostream>
using namespace std;

const int SIZE = 10;

int Multiply(int a, int b){
    // assume a and b are both positive values
    int result = 0;
    for(int i = 0; i < b; i ++){
        result = result + a;
    }
    return result;
}
int DotProduct(int v1[], int v2[], int size){
    int result = 0;
    for(int i=0; i < size; i ++){
        result += Multiply(v1[i], v2[i]);
    }
    return result;
}
void input_array(int v[], int size, int order){
    cout << "Please enter integers in array v"<<order<<"[] one by one: " <<endl;
    for(int i = 0; i < size; i++) {
        cout << "v"<<order<<"["<<i<<"]: ";
        cin >> v[i];
    }
}
int main(){
    int v1[SIZE];
    int v2[SIZE];
    int result = 0;

    input_array(v1, SIZE, 1);
    input_array(v2, SIZE, 2);

    result = DotProduct(v1, v2, SIZE);
    cout << "Final result of the vector dot product V1 and V2 is : " << result << endl;
    return 0;
}