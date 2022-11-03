// C++ Implementation of the Quick Sort Algorithm.
#include <iostream>
using namespace std;
const int SIZE = 10;

void Swap(int arr[], int a, int b)
{
    int t = arr[a];
    arr[a] = arr[b];
    arr[b] = t;
}

int Partition(int arr[], int start, int end)
{

    int pivot = arr[start];

    int count = 0;
    for (int i = start + 1; i <= end; i++)
    {
        if (arr[i] <= pivot)
            count++;
    }

    // Giving pivot element its correct position
    int pivotIndex = start + count;
    Swap(arr, pivotIndex, start);

    // Sorting left and right parts of the pivot element
    int i = start, j = end;

    while (i < pivotIndex && j > pivotIndex)
    {
        while (arr[i] <= pivot)
        {
            i++;
        }
        while (arr[j] > pivot)
        {
            j--;
        }
        if (i < pivotIndex && j > pivotIndex)
        {
            Swap(arr, i++, j--);
        }
    }

    return pivotIndex;
}

void Quicksort(int arr[], int start, int end)
{

    // base case
    if (end <= start)
        return;

    // Partitioning the array
    int p = Partition(arr, start, end);

    // Sorting the left part
    Quicksort(arr, start, p - 1);

    // Sorting the right part
    Quicksort(arr, p + 1, end);
}

int main()
{
    int arr[SIZE];
    cout << "Please enter integers in array A[] one by one: " << endl;
    for (int i = 0; i < SIZE; i++)
    {
        cout << "A[" << i << "]: ";
        cin >> arr[i];
    }

    Quicksort(arr, 0, SIZE - 1);
    // The output of the sorted array:
    cout << "The sorted array A[] is :";
    for (int i = 0; i < SIZE; i++)
    {
        cout <<arr[i] << " ";
    }

    return 0;
}