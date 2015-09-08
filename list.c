#include <stdio.h>
#include <stdlib.h>

typedef struct tagListNode {
	struct tagListNode *prev;
	struct tagListNode *next;
	int data;
} ListNode;

int main(void)
{
	int buf, sum;
	ListNode *firstnode, *lastnode, *newnode, *thisnode, *removenode;

	firstnode = lastnode = NULL;

	do {
		printf("Enter integer. (terminate with zero): ");
		scanf("%d", &buf);
		if (buf) {
			newnode = (ListNode*)malloc(sizeof(ListNode));
			newnode->data = buf;
			newnode->next = NULL;

			if (lastnode != NULL) {
				lastnode->next = newnode;
				newnode->prev = lastnode;
				lastnode = newnode;
			} else {
				firstnode = lastnode = newnode;
				newnode->prev = NULL;
			}
		}
	} while (buf != 0);

	sum = 0;
	for (thisnode = firstnode; thisnode != NULL; thisnode = thisnode->next) {
		sum += thisnode->data;
		if (thisnode == firstnode) continue;
		printf("%d + %d = %d\n", sum - thisnode->data, thisnode->data, sum);
	}
	printf("%d\n", sum);
	printf("%d\n", firstnode->data);
	printf("%d\n", firstnode->next->data);
	printf("%d\n", firstnode->next->next->data);
	printf("%d\n", lastnode->data);
	printf("%d\n", lastnode->prev->data);
	printf("%d\n", lastnode->prev->prev->data);

	for (thisnode = firstnode; thisnode != NULL;) {
		removenode = thisnode;
		thisnode = thisnode->next;
		free(removenode);
	}

	return EXIT_SUCCESS;
}
