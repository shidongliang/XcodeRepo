//
//  main.cpp
//  VirtualFunc
//
//  Created by MacBook Pro on 14-9-1.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#define MIN(a,b)  (a>b?a:b)
#define N 50
#include <iostream>
int main(int argc, const char * argv[])
{
    
    int a[N];
    int b[N];
    int c[N+N];
    for (int var =0; var<N;var++ ) {
        a[var]=9;
        b[var]=9;
        c[var]=0;
        c[var+N] = 0;
    }
    
    for (int i = N-1; 0<=i; i--) {
        int carrier = 0;
//        int higherCarrier = 0;
        for (int j=N-1; 0<=j; j--) {
            int tmp = a[i]*b[j]; //乘积
            std::cout<<"c["<<i+j+1<<"] : = "<<c[i+j+1]<<'\n';
            int sum = (c[i+j+1] + tmp);                         //第(i+j+1)位和
//            higherCarrier = low/10;//低位和大于10则进位增加
//            c[i+j+1] = low%10;
//            carrier = (tmp+carrier)/10;
            std::cout<<"sum : = "<<sum<<'\n';
            c[i+j+1] = sum%10;                                      //本轮第（i+j+1）位的显示数字
            std::cout<<"c["<<i+j+1<<"] : = "<<c[i+j+1]<<'\n';
            carrier = sum/10;                                           //本轮第（i+j+1）位的进位
            std::cout<<"carrier : = "<<carrier<<'\n';
            c[i+j] += carrier;                                            //本轮高位的和
            std::cout<<"c["<<i+j<<"] : = "<<c[i+j]<<'\n';
            std::cout<<"---------------"<<'\n';
        }
        std::cout<<"*******"<<'\n';
        for (int k= 0; k<N+N; k++) {
            std::cout<<"c["<<k<<"] "<<c[k]<<std::endl;
        }
    }
    return 0;
}

