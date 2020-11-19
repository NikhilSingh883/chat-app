#include <stdio.h>
#include<stdlib.h>
#include <string.h>
int process[500][6];
int readFile(){
    char const* const fileName = "inputFile.txt";
    FILE* file = fopen(fileName, "r"); 
    
    if(!file){
        printf("\n Unable to open : %s ", fileName);
        return 0;
    }
    
    char line[500];
    int index = 0; 
    while (fgets(line, sizeof(line), file)) {
        
        char *ptr = strtok(line, " "); 
        
        int check = 0; 
        while(ptr != NULL)
        {
            if(check == 1)
                process[index][1] = atoi(ptr);
            else 
                process[index][2] = atoi(ptr);
            ++check;
            ptr = strtok(NULL, " ");
        }
        
        index++;
        process[index-1][0] = index;
    }
    
    fclose(file);
    return index;
}

void swap(int *a, int *b) 
{ 
    int temp = *a; 
    *a = *b; 
    *b = temp; 
} 

void sort(int size){
    int i, j;
    for(i = 0;i<size;++i){
        for(j = i+1 ;j<size;++j)
            if(process[i][1] > process[j][1]){
                int tempNum, tempArrival, tempBurst;
                tempNum = process[i][0];
                tempArrival = process[i][1];
                tempBurst = process[i][2];
                process[i][0] = process[j][0];
                process[i][1] = process[j][1];
                process[i][2] = process[j][2];
                process[j][0] = tempNum;
                process[j][1] = tempArrival;
                process[j][2] = tempBurst;
            }
    }
}

void completionTime(int num) 
{ 
    int temp, val; 
    process[0][3] = process[0][1] + process[0][2]; 
    process[0][5] = process[0][3] - process[0][1]; 
    process[0][4] = process[0][5] - process[0][2]; 
      
    for(int i=1; i<num; i++) 
    { 
        temp = process[i-1][3]; 
        int low = process[i][2]; 
        for(int j=i; j<num; j++) 
        { 
            if(temp >= process[j][1] && low >= process[j][2]) 
            { 
                low = process[j][2]; 
                val = j; 
            } 
        } 
        process[val][3] = temp + process[val][2]; 
        process[val][5] = process[val][3] - process[val][1]; 
        process[val][4] = process[val][5] - process[val][2]; 
        for(int k=0; k<6; k++) 
        { 
            
            int temp = process[val][k];
            process[val][k] = process[i][k];
            process[i][k] = temp;
        } 
    } 
}

int main(){
    int size = readFile();
    sort(size);
    int i;
    for(i = 0;i<size;++i){
        printf("%d %d %d\n",process[i][0], process[i][1], process[i][2]);
    }
    
    completionTime(size);
    for(i = 0;i<size;++i){
        printf("waiting time for process %d is %d\n", process[i][0], process[i][4]);
    }
    int sum = 0;
    for(i = 0;i<size;++i){
        printf("turnaround time for process %d is %d\n", process[i][0], process[i][5]);
        sum+=process[i][5];
    }
    printf("\n\nAverage turnaround is %f", (sum*1.0)/size);

}