#include <iostream>
using namespace std;

void SpiralMatrix(int spiral[], int n)
{
    int row1 = 0, row2 = n - 1;
    int column1 = n - 1, column2 = 0;
    int aijValue = 1;
    int i, j;

    while (row1 <= row2 && column1 >= column2)
    {
        // fill out aij, where i=row1; j=column1,...,column2
        i = row1;
        for (j = column1; j >= column2; j--)
        {
            cout << "f1" << endl;
            spiral[i * n + j] = aijValue++;
        }

        // fill out aij, where i=row1+1,...,row2; j=column2
        j = column2;
        for (i = row1 + 1; i <= row2; i++)
        {
            cout << "f2" << endl;
            spiral[i * n + j] = aijValue++;
        }


        // fill out aij, where i=row2; j=column2+1,...,column1-1
        i = row2;
        for (j = column2 + 1; j < column1; j++)
        {
            cout << "f3" << endl;
            spiral[i * n + j] = aijValue++;
        }





        // fill out aij, where i=row2,...,row1+1; j=column1
        j = column1;
        for (i = row2; i > row1; i--)
        {
            cout << "f4" << endl;
            spiral[i * n + j] = aijValue++;
        }

        row1++;
        row2--;
        column1--;
        column2++;
    }
}

void PrintMatrix(const int spiral[], int n)
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            cout << spiral[i * n + j] << "\t";
        }
        cout << endl;
    }
}

int main()
{
    int spiral[100] = {};
    int n;
    cout << "Please enter an integer(1-10):" << endl;
    cin >> n;
    SpiralMatrix(spiral, n);
    cout << "The spiral matrix is:" << endl;
    PrintMatrix(spiral, n);
}
