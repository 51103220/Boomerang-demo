int fib(int param1);

// address: 0x1071c
int main(int argc, char *argv[], char *envp[]) {
    int local0; 		// m[o6 - 20]
    int o0; 		// r8

    printf("Input number: ");
    scanf("%d", &local0);
    o0 = fib(local0);
    printf("fibonacci(%d) = %d\n", local0, o0);
    return 0;
}

// address: 0x106ac
int fib(int param1) {
    int g1; 		// r1
    int local19; 		// m[o6 - 20]
    int o0; 		// r8
    int o0_1; 		// r8{43}

    if (param1 <= 1) {
        g1 = param1;
        local19 = param1;
    } else {
        o0 = fib(param1 - 1);
        o0_1 = fib(param1 - 2); /* Warning: also results in g1 */
        local19 = o0 + o0_1;
    }
    return local19; /* WARNING: Also returning: g1 := g1 */
}

