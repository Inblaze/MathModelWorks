#include <iostream>
#include <algorithm>
#include <queue>
using namespace std;
//Floyd算法
const int INF = 0x3f3f3f3f; //2^31-1
const int MAXN = 6000;

int G[MAXN][MAXN] = {0}; //邻接矩阵
int node, edge, start;

void input();
void Floyd();
void output(const int &);

int main() {
	input();//输入数据
	Floyd();
	output(start);//输出最终的结果
	return 0;
}

void input() {
	for (int i = 1; i < MAXN; i++) { //初始化
		for (int j = 1; j < MAXN; j++)
			G[i][j] = INF;
	}
	int from, to, w;
	cin >> node >> edge >> start;
	for (int i = 1; i <= edge; i++) {
		cin >> from >> to >> w;
		G[from][to] = w;
	}
}

void output(const int &s) {
	G[s][s] = 0;
	for (int i = 1; i <= node; i++)
		cout << G[s][i] << " ";
}

void Floyd() {
	for (int k = 1; k <= node; k++) {
		for (int i = 1; i <= node; i++) {
			for (int j = 1; j <= node; j++)
				G[i][j] = min(G[i][j], G[i][k] + G[k][j]);
		}
	}
}