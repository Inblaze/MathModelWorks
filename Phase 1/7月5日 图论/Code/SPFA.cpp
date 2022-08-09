#include <iostream>
#include <algorithm>
#include <queue>
using namespace std;
//BF�㷨
const int INF = 2147483647; //2^31-1
const int MAXN = 6000006;

struct Edge {
	int to;//�յ�
	int w;//Ȩֵ
	int next;//ʵ��������һ��
};//ǰ����-��̬�������ڽӱ�

struct Node { //���Խ������ȶ���
	int node;//���
	int cost;//����ñ�Ž��Ĵ���
	bool operator<(const Node &n)const {
		return cost > n.cost;
	}
};

Edge edgeTo[MAXN];//�븸�ڵ�
int head[MAXN];
int disTo[MAXN];//�õ����ڵ㵽����������·��
int node, edge, start, cnt = 1; //������������������㡢��ʽǰ���Ǽ���
queue<Node>q;
int onQ[MAXN] = {0};

void init();//head�����ʼ��
void add(const int &, const int &, const int &); //��ʽǰ���Ǽӱ�
void input();
void output();
void relax();
void SPFA(const int &);

int main() {
	input();
	SPFA(start);
	output();
	return 0;

}

void init() {
	for (int i = 0; i < node; i++)
		head[i] = -1;
}

void add(const int &from, const int &to, const int &w) {
	edgeTo[cnt].to = to;
	edgeTo[cnt].w = w;
	edgeTo[cnt].next = head[from]; //��ʼ��next=-1;����ͷ�巨��ָ�����
	head[from] = cnt++; //���ĵ�һ����ָ��cnt

}

void input() {
	int from, to, w;
	init();//��ʼ��
	cin >> node >> edge >> start;
	for (int i = 0; i < edge; i++) {
		cin >> from >> to >> w;
		add(from, to, w);
	}
}

void output() {
	for (int i = 1; i <= node; i++)
		cout << disTo[i] << " ";
}

void relax(int u) {
	for (int i = head[u]; i; i = edgeTo[i].next) {
		int &t = edgeTo[i].to;
		if (disTo[t] > disTo[u] + edgeTo[i].w) {
			disTo[t] = disTo[u] + edgeTo[i].w;
			if (!onQ[t]) {
				onQ[t] = 1;
				q.push(Node{t, disTo[t]});
			}

		}
	}
}

void SPFA(const int &s) { //���
	for (int i = 1; i <= node; i++)
		disTo[i] = INF;//��ʼ��
	disTo[s] = 0; //�������Ի���������ľ�����0
	q.push(Node{s, 0});
	onQ[s] = 1;

	while (!q.empty()) {
		int u = q.front().node;
		q.pop();
		onQ[u] = 0;
		relax(u);
	}

}