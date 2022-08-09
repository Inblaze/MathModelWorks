#include <iostream>
#include <algorithm>
#include <queue>
using namespace std;
//Floyd�㷨
const int INF = 0x3f3f3f3f; //2^31-1
const int MAXN = 6000;

int G[MAXN][MAXN] = {0}; //�ڽӾ���
int node, edge, start;

void input();
void Floyd();
void output(const int &);

int main() {
	input();//��������
	Floyd();
	output(start);//������յĽ��
	return 0;
}

void input() {
	for (int i = 1; i < MAXN; i++) { //��ʼ��
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