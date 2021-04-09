#include <stdio.h>

int ans[1025];

void func(int n)
{
    if(n<2){
        ans[n] = 1;
    }
    else{
        int j = n-100;
        if(j<0)
            j = 0;
            
        ans[n] = ans[j] + 2*ans[n/2] + 5;
    }
}

int main()
{
    for(int i=0; i<1025; i++)
    {
        func(i);
        printf("%d          %d\n", i, ans[i]);
    }
    return 0;
}