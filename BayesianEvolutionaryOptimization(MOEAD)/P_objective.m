function [Output,Boundary,Coding] = P_objective(Operation,Problem,M,Input)
% 返回对于多目标测试函数的相关操作所产生的结果
% 输入: Operation, 指定的操作, 包括产生初始种群,计算函数值,产生真实采点等
%       Problem,   指定的测试问题
%       M,         测试问题的维数
%       Input,     相关操作的主要输入, 不同的操作对应不同的含义
% 输出: Output,    此次操作的主要输出, 不同的操作对应不同的含义
%       Boundary,  指定的测试问题的决策空间, 仅在产生初始种群的操作中返回
%       Coding     指定的测试问题的编码方式, 仅在产生初始种群的操作中返回

    k = find(~isstrprop(Problem,'digit'),1,'last');
    switch Problem(1:k)
        case 'DTLZ'
            [Output,Boundary,Coding] = P_DTLZ(Operation,Problem,M,Input);
        case 'WFG'
            [Output,Boundary,Coding] = P_WFG(Operation,Problem,M,Input);
        case 'ZDT'
            [Output,Boundary,Coding] = P_ZDT(Operation,Problem,Input);
        case 'UF'
            [Output,Boundary,Coding] = P_UF(Operation,Problem,Input);
        case 'MOP'
            [Output,Boundary,Coding] = P_MOP(Operation,Problem,Input);
        case 'MOKP'
            [Output,Boundary,Coding] = P_MOKP(Operation,Problem,M,Input);
        otherwise
            error(['问题',Problem,'不存在.']);
    end
end

function [Output,Boundary,Coding] = P_DTLZ(Operation,Problem,M,Input)
    persistent K;
    Boundary = NaN; Coding = NaN;
    switch Operation
        %产生初始种群
        case 'init'
            k = find(~isstrprop(Problem,'digit'),1,'last');
            %m=3
%                 K = [98 98 98 98 98 98 98];
%                   K = [498 498 498 498 498 498 498];
              K = [5 10 10 10 10 10 20];
%                K = [998 998 998 998 998 998 998];
             %m=5
%                  K=[496 496 496 496 496 496 496];
%             K = [996 996 996 996 996 996 996];
%   K = [7 7 7 7 7 7 7];
            K = K(str2double(Problem(k+1:end)));
            
            D = M+K-1;
            MaxValue   = ones(1,D);
            MinValue   = zeros(1,D);
            Population = rand(Input,D);
            Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);
            
            Output   = Population;
            Boundary = [MaxValue;MinValue];
            Coding   = 'Real';
        %计算目标函数值 
        case 'value'
            Population    = Input;
            FunctionValue = zeros(size(Population,1),M);
%              k = find(~isstrprop(Problem,'digit'),1,'last');
          %m=3
%              K = [998 998 998 998 998 998 998];
%                K = [498 498 498 498 498 498 498];
%               K = [98 98 98 98 98 98 98];
%                K = [5 10 10 10 10 10 20];
%                  K = [1998 1998 1998 1998 1998 1998 1998];
%              K = K(str2double(Problem(k+1:end)));
               %m=5
%                 K=[496 496 496 496 496 496 496];
%             K = [996 996 996 996 996 996 996];
%  K = [7 7 7 7 7 7 7];
%              D = M+K-1;
            K = size(Population',1) - M + 1;
            switch Problem
                case 'DTLZ1'
                    
                    g = 100*(K+sum((Population(:,M:end)-0.5).^2-cos(20.*pi.*(Population(:,M:end)-0.5)),2));
                    for i = 1 : M
                        FunctionValue(:,i) = 0.5.*prod(Population(:,1:M-i),2).*(1+g);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*(1-Population(:,M-i+1));
                        end
                    end
                case 'DTLZ2'
                    g = sum((Population(:,M:end)-0.5).^2,2);
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ3'
                    g = 100*(K+sum((Population(:,M:end)-0.5).^2-cos(20.*pi.*(Population(:,M:end)-0.5)),2));
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ4'
                    Population(:,1:M-1) = Population(:,1:M-1).^100;
                    g = sum((Population(:,M:end)-0.5).^2,2);
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ5'
                    g    = sum((Population(:,M:end)-0.5).^2,2);
                    Temp = repmat(g,1,M-2);
                    Population(:,2:M-1) = (1+2*Temp.*Population(:,2:M-1))./(2+2*Temp);
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ6'
                    g    = sum(Population(:,M:end).^0.1,2);
                    Temp = repmat(g,1,M-2);
                    Population(:,2:M-1) = (1+2*Temp.*Population(:,2:M-1))./(2+2*Temp);
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ7'
                    g    = 1+9*mean(Population(:,M:end),2);
                    FunctionValue(:,1:M-1) = Population(:,1:M-1);
                    Temp = repmat(g,1,M-1);
                    h    = M-sum(FunctionValue(:,1:M-1)./(1+Temp).*(1+sin(3*pi.*FunctionValue(:,1:M-1))),2);
                    FunctionValue(:,M) = (1+g).*h;
            end
            Output = FunctionValue;
            %产生真实种群
        case 'true'
            
            switch Problem
                case 'DTLZ1'
                    P = UniformPoint(Input,M)/2;
                case {'DTLZ2','DTLZ3','DTLZ4'}
                     P = UniformPoint(Input,M);
                     P = P./repmat(sqrt(sum(P.^2,2)),1,M);
                case {'DTLZ5','DTLZ6'}
                    P = [0:1/(Input-1):1;1:-1/(Input-1):0]';
                    P = P./repmat(sqrt(sum(P.^2,2)),1,size(P,2));
                    P = [P(:,ones(1,M-2)),P];
                    P = P./sqrt(2).^repmat([M-2,M-2:-1:0],size(P,1),1);
                case 'DTLZ7'
                    interval     = [0,0.251412,0.631627,0.859401];
                    median       = (interval(2)-interval(1))/(interval(4)-interval(3)+interval(2)-interval(1));
                    X            = ReplicatePoint(Input,M-1);
                    X(X<=median) = X(X<=median)*(interval(2)-interval(1))/median+interval(1);
                    X(X>median)  = (X(X>median)-median)*(interval(4)-interval(3))/(1-median)+interval(3);
                    P            = [X,2*(M-sum(X/2.*(1+sin(3*pi.*X)),2))];
            end
            Output = P;
     %%   %产生真实种群
%         case 'true'
%             
%             switch Problem
%                 case 'DTLZ1'
%                     Population = T_uniform(Input,M);
%                     Population = Population/2;
%                 case {'DTLZ2','DTLZ3','DTLZ4'}
%                     Population = T_uniform(Input,M);
%                     for i = 1 : size(Population,1)
%                     	Population(i,:) = Population(i,:)./norm(Population(i,:));
%                     end
%                 case {'DTLZ5','DTLZ6'}
%                     Temp = [0:1/(Input-1):1]';
%                     Population = zeros(size(Temp,1),M);
%                     Population(:,1:M-1) = repmat(cos(0.5.*pi.*Temp),1,M-1);
%                     Population(:,M)     = sin(0.5.*pi.*Temp);
%                     Population(:,1)     = Population(:,1)/sqrt(2)^(M-2);
%                     Population(:,2:M)   = Population(:,2:M)./sqrt(2).^repmat(M-2:-1:0,size(Temp,1),1);
%                 case 'DTLZ7'
%                     Temp = T_repeat(Input,M-1);
%                     Population = zeros(size(Temp,1),M);
%                     Population(:,1:M-1) = Temp;
%                     Population(:,M)     = 2*(M-sum(Population(:,1:M-1)/2.*(1+sin(3*pi.*Population(:,1:M-1))),2));
%                     Population = T_sort(Population);
%             end
%             Output = Population;
        %计算收敛性
        case 'con'
            Population = Input;
            switch Problem
                case {'DTLZ1','DTLZ3'}
                    g = 100*(K+sum((Population(:,M:end)-0.5).^2-cos(20.*pi.*(Population(:,M:end)-0.5)),2));
                case {'DTLZ2','DTLZ4','DTLZ5'}
                    g = sum((Population(:,M:end)-0.5).^2,2);
                case 'DTLZ6'
                    g = sum(Population(:,M:end).^0.1,2);
                case 'DTLZ7'
                    g = 9*mean(Population(:,M:end),2);
            end
            Output = mean(g);
    end
end

function W = ReplicatePoint(SampleNum,M)
    if M > 1
        SampleNum = (ceil(SampleNum^(1/M)))^M;
        Gap       = 0:1/(SampleNum^(1/M)-1):1;
        eval(sprintf('[%s]=ndgrid(Gap);',sprintf('c%d,',1:M)))
        eval(sprintf('W=[%s];',sprintf('c%d(:),',1:M)))
    else
        W = (0:1/(SampleNum-1):1)';
    end
end

function [Output,Boundary,Coding] = P_WFG(Operation,Problem,M,Input)
    persistent K;
    persistent L;
    K = M - 1;
    L = 10;
    %L = 12 - K;
    Boundary = NaN; Coding = NaN;
    switch Operation
        %产生初始种群
        case 'init'
            %K = [20 10 10 10 10 10 10 10 10];
            
            %K = K(1);
               %K = K(str2double(Problem(K+1:end)));
             % K = K(1,2);
            
            %D = K+M - 1;
            %L = D - K;
            D = K + L; 
            
            MaxValue   = [1:D]*2;
            MinValue   = zeros(1,D);
            Population = rand(Input,D);
            Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);
            
            Output   = Population;
            Boundary = [MaxValue;MinValue];
            Coding   = 'Real';
        %计算目标函数值
        case 'value'
            %K = [10 10 10 10 10 10 10 10 10];
            %K = K(1);
            Population = Input;
            N = size(Population,1);
            D = 1;
            S = repmat([1:M]*2,N,1);
            if strcmp(Problem,'WFG3')
                A = [ones(N,1),zeros(N,M-2)];
            else
                A = ones(N,M-1);
            end
            z01 = Population./repmat([1:size(Population,2)]*2,N,1);
            switch Problem
                case 'WFG1'                    
                    t1 = zeros(N,K+L);
                    t1(:,1:K)     = z01(:,1:K);
                    t1(:,K+1:end) = s_linear(z01(:,K+1:end),0.35);

                    t2 = zeros(N,K+L);
                    t2(:,1:K)     = t1(:,1:K);
                    t2(:,K+1:end) = b_flat(t1(:,K+1:end),0.8,0.75,0.85);

                    t3 = zeros(N,K+L);
                    t3 = b_poly(t2,0.02);

                    t4 = zeros(N,M);
                    for i = 1 : M-1
                        t4(:,i) = r_sum(t3(:,(i-1)*K/(M-1)+1:i*K/(M-1)),2*((i-1)*K/(M-1)+1):2:2*i*K/(M-1));
                    end
                    t4(:,M) = r_sum(t3(:,K+1:K+L),2*(K+1):2:2*(K+L));

                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t4(:,M),A(:,i)).*(t4(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t4(:,M);
                    
                    h      = convex(x);
                    h(:,M) = mixed(x);
                case 'WFG2'                    
                    t1 = zeros(N,K+L);
                    t1(:,1:K)     = z01(:,1:K);
                    t1(:,K+1:end) = s_linear(z01(:,K+1:end),0.35);
                    
                    t2 = zeros(N,K+L/2);
                    t2(:,1:K) = t1(:,1:K);
                    for i = K+1 : K+L/2
                        t2(:,i) = r_nonsep(t1(:,K+2*(i-K)-1:K+2*(i-K)),2);
                    end
                    
                    t3 = zeros(N,M);
                    for i = 1 : M-1
                        t3(:,i) = r_sum(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t3(:,M) = r_sum(t2(:,K+1:K+L/2),ones(1,L/2));
                    
                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t3(:,M);
                    
                    h      = convex(x);
                    h(:,M) = disc(x);
                case 'WFG3'
                    t1 = zeros(N,K+L);
                    t1(:,1:K)     = z01(:,1:K);
                    t1(:,K+1:end) = s_linear(z01(:,K+1:end),0.35);
                    
                    t2 = zeros(N,K+L/2);
                    t2(:,1:K) = t1(:,1:K);
                    for i = K+1 : K+L/2
                        t2(:,i) = r_nonsep(t1(:,K+2*(i-K)-1:K+2*(i-K)),2);
                    end
                    
                    t3 = zeros(N,M);
                    for i = 1 : M-1
                        t3(:,i) = r_sum(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t3(:,M) = r_sum(t2(:,K+1:K+L/2),ones(1,L/2));
                    
                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t3(:,M);
                    
                    h = linear(x);
                case 'WFG4'
                    t1 = zeros(N,K+L);
                    t1 = s_multi(z01,30,10,0.35);

                    t2 = zeros(N,M);
                    for i = 1 : M-1
                        t2(:,i) = r_sum(t1(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t2(:,M) = r_sum(t1(:,K+1:K+L),ones(1,L));
                    
                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t2(:,M),A(:,i)).*(t2(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t2(:,M);
                    
                    h = concave(x);
                case 'WFG5'
                    t1 = zeros(N,K+L);
                    t1 = s_decept(z01,0.35,0.001,0.05);
                    
                    t2 = zeros(N,M);
                    for i = 1 : M-1
                        t2(:,i) = r_sum(t1(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t2(:,M) = r_sum(t1(:,K+1:K+L),ones(1,L));
                    
                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t2(:,M),A(:,i)).*(t2(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t2(:,M);
                    
                    h = concave(x);
                case 'WFG6'
                    t1 = zeros(N,K+L);
                    t1(:,1:K)     = z01(:,1:K);
                    t1(:,K+1:end) = s_linear(z01(:,K+1:end),0.35);
                    
                    t2 = zeros(N,M);
                    for i = 1 : M-1
                        t2(:,i) = r_nonsep(t1(:,(i-1)*K/(M-1)+1:i*K/(M-1)),K/(M-1));
                    end
                    t2(:,M) = r_nonsep(t1(:,K+1:end),L);
                    
                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t2(:,M),A(:,i)).*(t2(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t2(:,M);
                    
                    h = concave(x);                    
                case 'WFG7'
                    t1 = zeros(N,K+L);
                    for i = 1 : K
                        t1(:,i) = b_param(z01(:,i),r_sum(z01(:,i+1:end),ones(1,K+L-i)),0.98/49.98,0.02,50);
                    end
                    t1(:,K+1:end) = z01(:,K+1:end);
                    
                    t2 = zeros(N,K+L);
                    t2(:,1:K)     = t1(:,1:K);
                    t2(:,K+1:end) = s_linear(t1(:,K+1:end),0.35);
                    
                    t3 = zeros(N,M);
                    for i = 1 : M-1
                        t3(:,i) = r_sum(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t3(:,M) = r_sum(t2(:,K+1:K+L),ones(1,L));
                    
                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t3(:,M);
                    
                    h = concave(x);
                case 'WFG8'
                    t1 = zeros(N,K+L);
                    t1(:,1:K) = z01(:,1:K);
                    for i = K+1 : K+L
                        t1(:,i) = b_param(z01(:,i),r_sum(z01(:,1:i-1),ones(1,i-1)),0.98/49.98,0.02,50);
                    end
                    
                    t2 = zeros(N,K+L);
                    t2(:,1:K)     = t1(:,1:K);
                    t2(:,K+1:end) = s_linear(t1(:,K+1:end),0.35);
                    
                    t3 = zeros(N,M);
                    for i = 1 : M-1
                        t3(:,i) = r_sum(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t3(:,M) = r_sum(t2(:,K+1:K+L),ones(1,L));
                    
                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t3(:,M);
                    
                    h = concave(x);
                case 'WFG9'
                    t1 = zeros(N,K+L);
                    for i = 1 : K+L-1
                        t1(:,i) = b_param(z01(:,i),r_sum(z01(:,i+1:end),ones(1,K+L-i)),0.98/49.98,0.02,50);
                    end
                    t1(:,end) = z01(:,end);
                    
                    t2 = zeros(N,K+L);
                    t2(:,1:K)     = s_decept(t1(:,1:K),0.35,0.001,0.05);
                    t2(:,K+1:end) = s_multi(t1(:,K+1:end),30,95,0.35);
                    
                    t3 = zeros(N,M);
                    for i = 1 : M-1
                        t3(:,i) = r_nonsep(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),K/(M-1));
                    end
                    t3(:,M) = r_nonsep(t2(:,K+1:end),L);
                    
                    x = zeros(N,M);
                    for i = 1 : M-1
                        x(:,i) = max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M) = t3(:,M);
                    
                    h = concave(x);
            end
            Output = repmat(D*x(:,M),1,M)+S.*h;
        %产生真实种群
        case 'true'
            switch Problem
                case {'WFG1','WFG2'}
                    h = T_uniform(Input,M);
                    for i = 1 : size(h,1)
                        c = ones(1,M-1);
                        k = find(h(i,:)~=0,1);
                        for j = k+1 : M
                            Temp = h(i,j)/h(i,k)*prod(1-c(M-j+2:M-k));
                            if k > 1
                                Temp = Temp*(1-sqrt(1-c(M-k+1)^2));
                            end
                            c(M+1-j) = (Temp^2-Temp+sqrt(2*Temp))/(Temp^2+1);
                        end
                        for j = 1 : M
                            h(i,j) = prod(1-c(1:M-j));
                            if j > 1
                                h(i,j) = h(i,j).*(1-sqrt(1-c(M-j+1)^2));
                            end
                        end
                        Temp = acos(c(1))*2/pi;
                        if strcmp(Problem,'WFG1')                      
                            h(i,M) = 1-Temp-cos(10*pi*Temp+pi/2)/10/pi;
                        else
                            h(i,M) = 1-Temp.*(cos(5*pi*Temp)).^2;
                        end
                    end
                    if strcmp(Problem,'WFG2')
                        h = T_sort(h);
                    end
                case 'WFG3'
                    Population = [0:1/(Input-1):1]';
                    Population = [Population,zeros(size(Population,1),M-2)+0.5];
                    Population = [Population,zeros(size(Population,1),1)];
                    h = linear(Population);
                case {'WFG4','WFG5','WFG6','WFG7','WFG8','WFG9'}
                    h = T_uniform(Input,M);
                    for i = 1 : size(h,1)
                    	h(i,:) = h(i,:)./norm(h(i,:));
                    end
            end           
            Output = repmat([1:M]*2,size(h,1),1).*h;
        %计算收敛性
        case 'con'
            Population = Input;
            N   = size(Population,1);
            z01 = Population./repmat([1:size(Population,2)]*2,N,1);
            switch Problem
                case 'WFG1'
                    t1 = zeros(N,K+L);
                    t1(:,K+1:end) = s_linear(z01(:,K+1:end),0.35);

                    t2 = zeros(N,K+L);
                    t2(:,K+1:end) = b_flat(t1(:,K+1:end),0.8,0.75,0.85);

                    t3 = zeros(N,K+L);
                    t3 = b_poly(t2,0.02);

                    t4 = zeros(N,M);
                    t4(:,M) = r_sum(t3(:,K+1:K+L),2*(K+1):2:2*(K+L));

                    x = zeros(N,M);
                    x(:,M) = t4(:,M);
                case 'WFG2'                    
                    t1 = zeros(N,K+L);
                    t1(:,K+1:end) = s_linear(z01(:,K+1:end),0.35);
                    
                    t2 = zeros(N,K+L/2);
                    for i = K+1 : K+L/2
                        t2(:,i) = r_nonsep(t1(:,K+2*(i-K)-1:K+2*(i-K)),2);
                    end
                    
                    t3 = zeros(N,M);
                    t3(:,M) = r_sum(t2(:,K+1:K+L/2),ones(1,L/2));
                    
                    x = zeros(N,M);
                    x(:,M) = t3(:,M);
                case 'WFG3'
                    t1 = zeros(N,K+L);
                    t1(:,K+1:end) = s_linear(z01(:,K+1:end),0.35);
                    
                    t2 = zeros(N,K+L/2);
                    for i = K+1 : K+L/2
                        t2(:,i) = r_nonsep(t1(:,K+2*(i-K)-1:K+2*(i-K)),2);
                    end
                    
                    t3 = zeros(N,M);
                    t3(:,M) = r_sum(t2(:,K+1:K+L/2),ones(1,L/2));
                    
                    x = zeros(N,M);
                    x(:,M) = t3(:,M);
                case 'WFG4'
                    t1 = zeros(N,K+L);
                    t1 = s_multi(z01,30,10,0.35);
                    
                    t2 = zeros(N,M);
                    t2(:,M) = r_sum(t1(:,K+1:K+L),ones(1,L));
                    
                    x = zeros(N,M);
                    x(:,M) = t2(:,M);
                case 'WFG5'
                    t1 = zeros(N,K+L);
                    t1 = s_decept(z01,0.35,0.001,0.05);
                    
                    t2 = zeros(N,M);
                    t2(:,M) = r_sum(t1(:,K+1:K+L),ones(1,L));
                    
                    x = zeros(N,M);
                    x(:,M) = t2(:,M);
                case 'WFG6'
                    t1 = zeros(N,K+L);
                    t1(:,K+1:end) = s_linear(z01(:,K+1:end),0.35);
                    
                    t2 = zeros(N,M);
                    t2(:,M) = r_nonsep(t1(:,K+1:end),L);
                    
                    x = zeros(N,M);
                    x(:,M) = t2(:,M);                   
                case 'WFG7'
                    t1 = zeros(N,K+L);
                    t1(:,K+1:end) = z01(:,K+1:end);
                    
                    t2 = zeros(N,K+L);
                    t2(:,K+1:end) = s_linear(t1(:,K+1:end),0.35);
                    
                    t3 = zeros(N,M);
                    t3(:,M) = r_sum(t2(:,K+1:K+L),ones(1,L));
                    
                    x = zeros(N,M);
                    x(:,M) = t3(:,M);
                case 'WFG8'
                    t1 = zeros(N,K+L);
                    for i = K+1 : K+L
                        t1(:,i) = b_param(z01(:,i),r_sum(z01(:,1:i-1),ones(1,i-1)),0.98/49.98,0.02,50);
                    end
                    
                    t2 = zeros(N,K+L);
                    t2(:,K+1:end) = s_linear(t1(:,K+1:end),0.35);
                    
                    t3 = zeros(N,M);
                    t3(:,M) = r_sum(t2(:,K+1:K+L),ones(1,L));
                    
                    x = zeros(N,M);
                    x(:,M) = t3(:,M);
                case 'WFG9'
                    t1 = zeros(N,K+L);
                    for i = 1 : K+L-1
                        t1(:,i) = b_param(z01(:,i),r_sum(z01(:,i+1:end),ones(1,K+L-i)),0.98/49.98,0.02,50);
                    end
                    t1(:,end) = z01(:,end);
                    
                    t2 = zeros(N,K+L);
                    t2(:,K+1:end) = s_multi(t1(:,K+1:end),30,95,0.35);
                    
                    t3 = zeros(N,M);
                    t3(:,M) = r_nonsep(t2(:,K+1:end),L);
                    
                    x = zeros(N,M);
                    x(:,M) = t3(:,M);
            end
            Output = mean(x(:,M));
    end
end

%用于计算WFG函数值的变换函数
function Output = b_poly(y,a)
    Output = y.^a;
end

function Output = b_flat(y,A,B,C)
    Output = A+min(0,floor(y-B))*A.*(B-y)/B-min(0,floor(C-y))*(1-A).*(y-C)/(1-C);
    Output = roundn(Output,-6);
end

function Output = b_param(y,Y,A,B,C)
    Output = y.^(B+(C-B)*(A-(1-2*Y).*abs(floor(0.5-Y)+A)));
end

function Output = s_linear(y,A)
    Output = abs(y-A)./abs(floor(A-y)+A);
end

function Output = s_decept(y,A,B,C)
    Output = 1+(abs(y-A)-B).*(floor(y-A+B)*(1-C+(A-B)/B)/(A-B)+floor(A+B-y)*(1-C+(1-A-B)/B)/(1-A-B)+1/B);
end

function Output = s_multi(y,A,B,C)
    Output = (1+cos((4*A+2)*pi*(0.5-abs(y-C)/2./(floor(C-y)+C)))+4*B*(abs(y-C)/2./(floor(C-y)+C)).^2)/(B+2);
end

function Output = r_sum(y,w)
    Output = sum(y.*repmat(w,size(y,1),1),2)./sum(w);
end

function Output = r_nonsep(y,A)
    Output = zeros(size(y,1),1);
    for j = 1 : size(y,2)
        Temp = zeros(size(y,1),1);
        for k = 0 : A-2
            Temp = Temp+abs(y(:,j)-y(:,1+mod(j+k,size(y,2))));
        end
        Output = Output+y(:,j)+Temp;
    end
    Output = Output./(size(y,2)/A)/ceil(A/2)/(1+2*A-2*ceil(A/2));
end

%用于计算WFG函数值的形状函数
function Output = linear(x)
    Output = zeros(size(x));
    for i = 1 : size(x,2)
        Output(:,i) = prod(x(:,1:size(x,2)-i),2);
        if i > 1
            Output(:,i) = Output(:,i).*(1-x(:,size(x,2)-i+1));
        end
    end
end

function Output = convex(x)
    Output = zeros(size(x));
    for i = 1 : size(x,2)
        Output(:,i) = prod(1-cos(x(:,1:end-i)*pi/2),2);  %prod 指的是返回每列元素的乘积
        if i > 1  
            Output(:,i) = Output(:,i).*(1-sin(x(:,size(x,2)-i+1)*pi/2));
        end
    end
end

function Output = concave(x)
    Output = zeros(size(x));
    for i = 1 : size(x,2)
        Output(:,i) = prod(sin(x(:,1:end-i)*pi/2),2);
        if i > 1
            Output(:,i) = Output(:,i).*(cos(x(:,size(x,2)-i+1)*pi/2));
        end
    end
end

function Output = mixed(x)
    Output = 1-x(:,1)-cos(10*pi*x(:,1)+pi/2)/10/pi;
end

function Output = disc(x)
    Output = 1-x(:,1).*(cos(5*pi*x(:,1))).^2;
end

function [Output,Boundary,Coding] = P_ZDT(Operation,Problem,Input)
    persistent K;
    Boundary = NaN; Coding = NaN;
    switch Operation
        %产生初始种群
        case 'init'
            k = find(~isstrprop(Problem,'digit'),1,'last');
            K = [30 30 30 10 11 10];
%             K = [1000 1000 1000 1000 1000 1000];
%                K = [500 500 500 500 500 500];
            K = K(str2double(Problem(k+1:end)));
            
            D = K;
            if strcmp(Problem,'ZDT5')
                Population = randi([0,1],Input,30+(D-1)*5);
                
                Output   = Population;
                Boundary = NaN;
                Coding   = 'Binary';
            else 
                if strcmp(Problem,'ZDT4')
                    MaxValue = [1,zeros(1,D-1)+5];
                    MinValue = [0,zeros(1,D-1)-5];
                else
                    MaxValue = ones(1,D);
                    MinValue = zeros(1,D);
                end
                Population = rand(Input,D);
                Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);

                Output   = Population;
                Boundary = [MaxValue;MinValue];
                Coding   = 'Real';
            end
        %计算目标函数值
        case 'value'
            Population    = Input;
            [N,D] = size(Population);
            FunctionValue = zeros(N,2);
            switch Problem
                case 'ZDT1'
                    FunctionValue(:,1) = Population(:,1);
                    g = 1+9*sum(Population(:,2:end),2);
                    h = 1-(FunctionValue(:,1)./g).^0.5;
                case 'ZDT2'
                    FunctionValue(:,1) = Population(:,1);
                    g = 1+9*sum(Population(:,2:end),2);
                    h = 1-(FunctionValue(:,1)./g).^2;
                case 'ZDT3'
                    FunctionValue(:,1) = Population(:,1);
                    g = 1+9*sum(Population(:,2:end),2);
                    h = 1-(FunctionValue(:,1)./g).^0.5-FunctionValue(:,1)./g.*sin(10*pi*FunctionValue(:,1));
                case 'ZDT4'
                    FunctionValue(:,1) = Population(:,1);
                    g = 1+10*(size(Population,2)-1)+sum(Population(:,2:end).^2-10*cos(4*pi*Population(:,2:end)),2);
                    h = 1-(FunctionValue(:,1)./g).^0.5;
                case 'ZDT5'
                    u = zeros(N,1+(D-30)/5);
                    u(:,1) = sum(Population(:,1:30),2);
                    for i = 2 : size(u,2)
                        u(:,i) = sum(Population(:,(i-2)*5+31:(i-2)*5+35),2);
                    end
                    v = zeros(size(u));
                    v(u<5)  = 2+u(u<5);
                    v(u==5) = 1;
                    FunctionValue(:,1) = 1+u(:,1);
                    g = sum(v(:,2:end),2);
                    h = 1./FunctionValue(:,1);
                case 'ZDT6'
                    FunctionValue(:,1) = 1-exp(-4*Population(:,1)).*sin(6*pi*Population(:,1)).^6;
                    g = 1+9*(sum(Population(:,2:end),2)).^0.25;
                    h = 1-(FunctionValue(:,1)./g).^2;
            end
            FunctionValue(:,2) = g.*h;
            Output = FunctionValue;
        %产生真实种群
        case 'true'
            Input = 1000;
            switch Problem
                case {'ZDT1','ZDT4'}
                    Population = zeros(Input,2);
                    Population(:,1) = T_repeat(Input,1);
                    Population(:,2) = 1-Population(:,1).^0.5;
                case {'ZDT2','ZDT6'}
                    Population = zeros(Input,2);
                    Population(:,1) = T_repeat(Input,1);
                    Population(:,2) = 1-Population(:,1).^2;
                case 'ZDT3'
                    Population = zeros(Input,2);
                    Population(:,1) = T_repeat(Input,1);
                    Population(:,2) = 1-Population(:,1).^0.5-Population(:,1).*sin(10*pi*Population(:,1));
                    Population = T_sort(Population);
                case 'ZDT5'
                    Population(:,1) = 1:31;
                    Population(:,2) = (K-1)./Population(:,1);
            end
            Output = Population;
        %计算收敛性
        case 'con'
            Population = Input;
            [N,D] = size(Population);
            switch Problem
                case {'ZDT1','ZDT2','ZDT3'}
                    g = 9*sum(Population(:,2:end),2);
                case 'ZDT4'
                    g = 10*(size(Population,2)-1)+sum(Population(:,2:end).^2-10*cos(4*pi*Population(:,2:end)),2);
                case 'ZDT5'
                    u = zeros(N,1+(D-30)/5);
                    u(:,1) = sum(Population(:,1:30),2);
                    for i = 2 : size(u,2)
                        u(:,i) = sum(Population(:,(i-2)*5+31:(i-2)*5+35),2);
                    end
                    v = zeros(size(u));
                    v(u<5)  = 2+u(u<5);
                    v(u==5) = 1;
                    g = sum(v(:,2:end),2);
                case 'ZDT6'
                    g = 9*sum(Population(:,2:end),2).^0.25;
            end
            Output = mean(g);
    end
end

function [Output,Boundary,Coding] = P_UF(Operation,Problem,Input)
    persistent K;
    Boundary = NaN; Coding = NaN;
    switch Operation
        %产生初始种群
        case 'init'
            K = 30;
%             K = 500;
            D = K;
            switch Problem
                case {'UF8','UF9','UF10'}
                    MaxValue = [1,1,zeros(1,D-2)+2];
                    MinValue = [0,0,zeros(1,D-2)-2];               
                case 'UF3'
                    MaxValue = ones(1,D);
                    MinValue = zeros(1,D);
                case 'UF4'
                    MaxValue = [1,zeros(1,D-1)+2];
                    MinValue = [0,zeros(1,D-1)-2];
                otherwise
                    MaxValue = ones(1,D);
                    MinValue = [0,zeros(1,D-1)-1];
            end
            Population = rand(Input,D);
            Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);
            
            Output   = Population;
            Boundary = [MaxValue;MinValue];
            Coding   = 'Real';
        %计算目标函数值
        case 'value'
            X = Input;
            [N,D] = size(X);
            switch Problem
                case 'UF1'
                    FunctionValue = zeros(N,2);
                    J1 = 3:2:D;
                    J2 = 2:2:D;
                    Y  = X - sin(6*pi*repmat(X(:,1),1,D)+repmat(1:D,N,1)*pi/D);
                    FunctionValue(:,1) = X(:,1)+2*mean(Y(:,J1).^2,2);
                    FunctionValue(:,2) = 1-sqrt(X(:,1))+2*mean(Y(:,J2).^2,2);
                case 'UF2'
                    FunctionValue = zeros(N,2);
                    J1 = 3:2:D;
                    J2 = 2:2:D;
                    Y  = zeros(size(X));
                    X1 = repmat(X(:,1),1,length(J1));
                    Y(:,J1) = X(:,J1)-(0.3*X1.^2.*cos(24*pi*X1+4*repmat(J1,N,1)*pi/D)+0.6*X1).*cos(6*pi*X1+repmat(J1,N,1)*pi/D);
                    X1 = repmat(X(:,1),1,length(J2));
                    Y(:,J2) = X(:,J2)-(0.3*X1.^2.*cos(24*pi*X1+4*repmat(J2,N,1)*pi/D)+0.6*X1).*sin(6*pi*X1+repmat(J2,N,1)*pi/D); 
                    FunctionValue(:,1) = X(:,1)+2*mean(Y(:,J1).^2,2);
                    FunctionValue(:,2) = 1-sqrt(X(:,1))+2*mean(Y(:,J2).^2,2);
                case 'UF3'
                    FunctionValue = zeros(N,2);
                    J1 = 3:2:D;
                    J2 = 2:2:D;
                    Y  = X - repmat(X(:,1),1,D).^(0.5*(1+3*(repmat(1:D,N,1)-2)/(D-2)));                  
                    FunctionValue(:,1) = X(:,1)+2/length(J1)*(4*sum(Y(:,J1).^2,2)-2*prod(cos(20*Y(:,J1)*pi./sqrt(repmat(J1,N,1))),2)+2);
                    FunctionValue(:,2) = 1-sqrt(X(:,1))+2/length(J2)*(4*sum(Y(:,J2).^2,2)-2*prod(cos(20*Y(:,J2)*pi./sqrt(repmat(J2,N,1))),2)+2);
                case 'UF4'
                    FunctionValue = zeros(N,2);
                    J1 = 3:2:D;
                    J2 = 2:2:D;
                    Y  = X - sin(6*pi*repmat(X(:,1),1,D)+repmat(1:D,N,1)*pi/D);
                    hY = abs(Y)./(1+exp(2*abs(Y)));
                    FunctionValue(:,1) = X(:,1)+2*mean(hY(:,J1),2);
                    FunctionValue(:,2) = 1-X(:,1).^2+2*mean(hY(:,J2),2);
                case 'UF5'
                    FunctionValue = zeros(N,2);
                    J1 = 3:2:D;
                    J2 = 2:2:D;
                    Y  = X - sin(6*pi*repmat(X(:,1),1,D)+repmat(1:D,N,1)*pi/D);
                    hY = 2*Y.^2-cos(4*pi*Y)+1;
                    FunctionValue(:,1) = X(:,1)+(1/20+0.1)*abs(sin(20*pi*X(:,1)))+2*mean(hY(:,J1),2);
                    FunctionValue(:,2) = 1-X(:,1)+(1/20+0.1)*abs(sin(20*pi*X(:,1)))+2*mean(hY(:,J2),2);
                case 'UF6'
                    FunctionValue = zeros(N,2);
                    J1 = 3:2:D;
                    J2 = 2:2:D;
                    Y  = X - sin(6*pi*repmat(X(:,1),1,D)+repmat(1:D,N,1)*pi/D);
                    FunctionValue(:,1) = X(:,1)+max(0,2*(1/4+0.1)*sin(4*pi*X(:,1)))+2/length(J1)*(4*sum(Y(:,J1).^2,2)-2*prod(cos(20*Y(:,J1)*pi./sqrt(repmat(J1,N,1))),2)+2);
                    FunctionValue(:,2) = 1-X(:,1)+max(0,2*(1/4+0.1)*sin(4*pi*X(:,1)))+2/length(J2)*(4*sum(Y(:,J2).^2,2)-2*prod(cos(20*Y(:,J2)*pi./sqrt(repmat(J2,N,1))),2)+2);
                case 'UF7'
                    FunctionValue = zeros(N,2);
                    J1 = 3:2:D;
                    J2 = 2:2:D;
                    Y  = X - sin(6*pi*repmat(X(:,1),1,D)+repmat(1:D,N,1)*pi/D);
                    FunctionValue(:,1) = X(:,1).^0.2+2*mean(Y(:,J1).^2,2);
                    FunctionValue(:,2) = 1-X(:,1).^0.2+2*mean(Y(:,J2).^2,2);
                case 'UF8'
                    FunctionValue = zeros(N,3);
                    J1 = 4:3:D;
                    J2 = 5:3:D;
                    J3 = 3:3:D;
                    Y  = X-2*repmat(X(:,2),1,D).*sin(2*pi*repmat(X(:,1),1,D)+repmat(1:D,N,1)*pi/D);
                    FunctionValue(:,1) = cos(0.5*X(:,1)*pi).*cos(0.5*X(:,2)*pi)+2*mean(Y(:,J1).^2,2);
                    FunctionValue(:,2) = cos(0.5*X(:,1)*pi).*sin(0.5*X(:,2)*pi)+2*mean(Y(:,J2).^2,2);
                    FunctionValue(:,3) = sin(0.5*X(:,1)*pi)+2*mean(Y(:,J3).^2,2);                    
                case 'UF9'
                    FunctionValue = zeros(N,3);
                    J1 = 4:3:D;
                    J2 = 5:3:D;
                    J3 = 3:3:D;
                    Y  = X-2*repmat(X(:,2),1,D).*sin(2*pi*repmat(X(:,1),1,D)+repmat(1:D,N,1)*pi/D);
                    FunctionValue(:,1) = 0.5*(max(0,1.1*(1-4*(2*X(:,1)-1).^2))+2*X(:,1)).*X(:,2)+2*mean(Y(:,J1).^2,2);
                    FunctionValue(:,2) = 0.5*(max(0,1.1*(1-4*(2*X(:,1)-1).^2))-2*X(:,1)+2).*X(:,2)+2*mean(Y(:,J2).^2,2);
                    FunctionValue(:,3) = 1-X(:,2)+2*mean(Y(:,J3).^2,2);
                case 'UF10'
                    FunctionValue = zeros(N,3);
                    J1 = 4:3:D;
                    J2 = 5:3:D;
                    J3 = 3:3:D;
                    Y  = X-2*repmat(X(:,2),1,D).*sin(2*pi*repmat(X(:,1),1,D)+repmat(1:D,N,1)*pi/D);
                    Y  = 4*Y.^2-cos(8*pi*Y)+1;
                    FunctionValue(:,1) = cos(0.5*X(:,1)*pi).*cos(0.5*X(:,2)*pi)+2*mean(Y(:,J1),2);
                    FunctionValue(:,2) = cos(0.5*X(:,1)*pi).*sin(0.5*X(:,2)*pi)+2*mean(Y(:,J2),2);
                    FunctionValue(:,3) = sin(0.5*X(:,1)*pi)+2*mean(Y(:,J3),2);
            end
            Output = FunctionValue;
        %产生真实种群
        case 'true'
            switch Problem
                case {'UF1','UF2','UF3'}
                    X = zeros(Input,2);
                    X(:,1) = T_repeat(Input,1);
                    X(:,2) = 1-X(:,1).^0.5;
                case 'UF4'
                    X = zeros(Input,2);
                    X(:,1) = T_repeat(Input,1);
                    X(:,2) = 1-X(:,1).^2;
                case 'UF5'
                    X(:,1) = [0:1:20]'/20;
                    X(:,2) = 1-X(:,1);
                case 'UF6'
                    X = zeros(Input,2);
                    X(:,1) = T_repeat(Input,1);
                    X(:,2) = 1-X(:,1);
                    X(X(:,1)>0 & X(:,1)<1/4 | X(:,1)>1/2 & X(:,1)<3/4,:) = [];
                case 'UF7'
                    X = zeros(Input,2);
                    X(:,1) = T_repeat(Input,1);
                    X(:,2) = 1-X(:,1);
                case {'UF8','UF10'}
                    X = P_DTLZ('true','DTLZ2',3,Input);
                case 'UF9'
                    X = P_DTLZ('true','DTLZ1',3,Input)*2;
                    X(X(:,1)>(1-X(:,3))/4 & X(:,1)<(1-X(:,3))*3/4,:) = [];
            end
            Output = X;
        %计算收敛性
        case 'con'
            X = Input;
            switch Problem
                case {'UF1','UF2','UF3'}
                    FunctionValue(:,1) = X(:,1);
                    FunctionValue(:,2) = 1-sqrt(X(:,1));
                case 'UF4'
                    FunctionValue(:,1) = X(:,1);
                    FunctionValue(:,2) = 1-X(:,1).^2;
                case 'UF5'
                    FunctionValue(:,1) = X(:,1)+(1/20+0.1)*abs(sin(20*pi*X(:,1)));
                    FunctionValue(:,2) = 1-X(:,1)+(1/20+0.1)*abs(sin(20*pi*X(:,1)));
                case 'UF6'
                    FunctionValue(:,1) = X(:,1)+max(0,2*(1/4+0.1)*sin(4*pi*X(:,1)));
                    FunctionValue(:,2) = 1-X(:,1)+max(0,2*(1/4+0.1)*sin(4*pi*X(:,1)));
                case 'UF7'
                    FunctionValue(:,1) = X(:,1).^0.2;
                    FunctionValue(:,2) = 1-X(:,1).^0.2;
                case {'UF8','UF10'}
                    FunctionValue(:,1) = cos(0.5*X(:,1)*pi).*cos(0.5*X(:,2)*pi);
                    FunctionValue(:,2) = cos(0.5*X(:,1)*pi).*sin(0.5*X(:,2)*pi);
                    FunctionValue(:,3) = sin(0.5*X(:,1)*pi);
                case 'UF9'
                    FunctionValue(:,1) = 0.5*(max(0,1.1*(1-4*(2*X(:,1)-1).^2))+2*X(:,1)).*X(:,2);
                    FunctionValue(:,2) = 0.5*(max(0,1.1*(1-4*(2*X(:,1)-1).^2))-2*X(:,1)+2).*X(:,2);
                    FunctionValue(:,3) = 1-X(:,2);
            end
            g = sum(P_UF('value',Problem,X)-FunctionValue,2);
            Output = mean(g);
    end
end

function [Output,Boundary,Coding] = P_MOP(Operation,Problem,Input)
    persistent K;
    Boundary = NaN; Coding = NaN;
    switch Operation
        %产生初始种群
        case 'init'
            K = 30;
%              K = 500;
            D = K;
            MaxValue   = ones(1,D);
            MinValue   = zeros(1,D);
            Population = rand(Input,D);
            Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);
            
            Output   = Population;
            Boundary = [MaxValue;MinValue];
            Coding   = 'Real';
        %计算目标函数值
        case 'value'
            X = Input;
            switch Problem
                case 'MOP1'
                    FunctionValue = zeros(size(X,1),3);
                    g = 9*mean(X(:,3:end),2);
                    r = max(0,2*(1-4*(2*X(:,1)-1).^2));
                    FunctionValue(:,1) = (r+sin(X(:,1)*pi/2)).*sin(X(:,2)*pi/2).*(1+g);
                    FunctionValue(:,2) = (r+cos(X(:,1)*pi/2)).*sin(X(:,2)*pi/2).*(1+g);
                    FunctionValue(:,3) = cos(X(:,2)*pi/2).*(1+g);
                case 'MOP2'
                    FunctionValue = zeros(size(X,1),3);
                    g = 9*mean(X(:,3:end),2);
                    r = max(0,2*(4*(2*X(:,1)-1).^2-1));
                    FunctionValue(:,1) = (r+X(:,1)).*X(:,2).*(1+g);
                    FunctionValue(:,2) = (r+1-X(:,1)).*X(:,2).*(1+g);
                    FunctionValue(:,3) = (1-X(:,2)).*(1+g);
                case 'MOP3'
                    FunctionValue = zeros(size(X,1),3);
                    g = 9*mean(X(:,3:end),2);
                    FunctionValue(:,1) = sin(X(:,1)*pi/2).*sin(X(:,2)*pi/2).*(1+g);
                    FunctionValue(:,2) = sin(X(:,1)*pi/2).*cos(X(:,2)*pi/2).*(1+g);
                    FunctionValue(:,3) = cos(X(:,1)*pi/2).*(1+g);
                    r = mean(5+10*(FunctionValue-0.5).^2+3.5*cos(2*pi*FunctionValue),2);
                    FunctionValue = FunctionValue.*repmat(r,1,3);
                case 'MOP4'
                    FunctionValue = zeros(size(X,1),3);
                    g = 9*mean(X(:,3:end),2);
                    FunctionValue(:,1:2) = X(:,1:2);
                    h = 3-sum(FunctionValue(:,1:2)./(1+repmat(g,1,2)).*(1+sin(7*pi.*FunctionValue(:,1:2))),2);
                    FunctionValue(:,3)   = (1+g).*h;
            end
            Output = FunctionValue;
        %产生真实种群
        case 'true'
            if strcmp(Problem,'MOP1')
                X = P_DTLZ('true','DTLZ2',3,Input);
                X(X(:,1)>sin(pi/8)*sqrt(1-X(:,3).^2) & X(:,1)<sin(3*pi/8)*sqrt(1-X(:,3).^2),:) = [];
            elseif strcmp(Problem,'MOP2')
                X = P_DTLZ('true','DTLZ1',3,Input)*2;
                X(X(:,1)<1/4*(1-X(:,3)) | X(:,1)>3/4*(1-X(:,3)),:) = [];
            elseif strcmp(Problem,'MOP3')
                X = T_uniform(Input,3);
                for i = 1 : size(X,1)
                    a = zeros(1,2);
                    k = find(X(i,:)~=0,1);
                    if k == 1
                        a(2) = acot(X(i,2)/X(i,1));
                        a(1) = acot(X(i,3)/X(i,1)*sin(a(2)));
                    elseif k == 2
                        a(1) = acot(X(i,3)/X(i,2));
                    end
                    X(i,1) = sin(a(1))*sin(a(2));
                    X(i,2) = sin(a(1))*cos(a(2));
                    X(i,3) = cos(a(1));
                    r = mean(5+10*(X(i,:)-0.5).^2+3.5*cos(2*pi*X(i,:)),2);
                    X(i,:) = X(i,:).*r;
                end
                X = T_sort(X);
            elseif strcmp(Problem,'MOP4')
                Temp = T_repeat(Input,2);
                X    = zeros(size(Temp,1),3);
                X(:,1:2) = Temp;
                X(:,3)   = 3-sum(X(:,1:2).*(1+sin(7*pi.*X(:,1:2))),2);
                X    = T_sort(X);
            end
            Output = X;
        %计算收敛性
        case 'con'
            X = Input;
            g = 9*mean(X(:,3:end),2);
            Output = mean(g);
    end
end

function [Output,Boundary,Coding] = P_MOKP(Operation,Problem,M,Input)
    persistent P W;
    Boundary = NaN; Coding = NaN;
    switch Operation
        %产生初始种群
        case 'init'
            k = find(~isstrprop(Problem,'digit'),1,'last');
            D = str2double(Problem(k+1:end));
            eval(['load Public/MOKP/',num2str(M),'-',num2str(D),' profit weight'])            
            P = profit;
            W = weight;
            
            Population = randi([0,1],Input,D);
            Population = P_MOKP('repair',Problem,M,Population);
            
            Output   = Population;
            Boundary = NaN;
            Coding   = 'Binary-MOKP';
        %计算目标函数值(最小化)
        case 'value'
            X = Input;
            N = size(X,1);
            M = size(P,1);
            FunctionValue = zeros(N,M);
            for i = 1 : N
                FunctionValue(i,:) = (sum(P,2)-sum(P.*repmat(X(i,:),M,1),2))';
            end
            Output = FunctionValue;
        %计算真实的目标函数值(最大化)
        case 'real'
            X = Input;
            N = size(X,1);
            M = size(P,1);
            FunctionValue = zeros(N,M);
            for i = 1 : N
                FunctionValue(i,:) = sum(P.*repmat(X(i,:),M,1),2)';
            end
            Output = FunctionValue;
        %修复
        case 'repair'
            X = Input;
            M = size(P,1);
            C = sum(W,2)/2;
            [~,Rank] = sort(max(P./W));
            for i = 1 : size(X,1)
            	Infeasible = sum(W.*repmat(X(i,:),M,1),2) > C;
                while any(Infeasible)
                    k = find(X(i,Rank),1);
                    X(i,Rank(k)) = 0;
                    Infeasible = sum(W.*repmat(X(i,:),M,1),2) > C;
                end
            end
            Output = X;
    end
end

%用于产生真实前沿面的辅助函数
function W = T_uniform(k,M)
%产生(约)k个M维的均匀分布向量,每个向量各维之和恒为1
    H = floor((k*prod(1:M-1))^(1/(M-1)));
    while nchoosek(H+M-1,M-1) >= k && H > 0
        H = H-1;
    end
    if nchoosek(H+M,M-1) <= 2*k || H == 0
        H = H+1;
    end
    k = nchoosek(H+M-1,M-1);
    Temp = nchoosek(1:H+M-1,M-1)-repmat(0:M-2,nchoosek(H+M-1,M-1),1)-1;
    W = zeros(k,M);
    W(:,1) = Temp(:,1)-0;
    for i = 2 : M-1
        W(:,i) = Temp(:,i)-Temp(:,i-1);
    end
    W(:,end) = H-Temp(:,end);
    W = W/H;
end
%%
function [W,N] = UniformPoint(N,M)
%UniformPoint - Generate a set of uniformly distributed points on the unit
%hyperplane.
%
%   [W,N] = UniformPoint(N,M) returns approximately N uniformly distributed
%   points with M objectives on the unit hyperplane.
%
%   Due to the requirement of uniform distribution, the number of points
%   cannot be arbitrary, and the number of points in W may be slightly
%   smaller than the predefined size N.
%
%   Example:
%       [W,N] = UniformPoint(275,10)

%------------------------------- Reference --------------------------------
% [1] I. Das and J. E. Dennis, Normal-boundary intersection: A new method
% for generating the Pareto surface in nonlinear multicriteria optimization
% problems, SIAM Journal on Optimization, 1998, 8(3): 631-657.
% [2] K. Deb and H. Jain, An evolutionary many-objective optimization
% algorithm using reference-point based non-dominated sorting approach,
% part I: Solving problems with box constraints, IEEE Transactions on
% Evolutionary Computation, 2014, 18(4): 577-601.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    H1 = 1;
    while nchoosek(H1+M,M-1) <= N
        H1 = H1 + 1;
    end
    W = nchoosek(1:H1+M-1,M-1) - repmat(0:M-2,nchoosek(H1+M-1,M-1),1) - 1;
    W = ([W,zeros(size(W,1),1)+H1]-[zeros(size(W,1),1),W])/H1;
    if H1 < M
        H2 = 0;
        while nchoosek(H1+M-1,M-1)+nchoosek(H2+M,M-1) <= N
            H2 = H2 + 1;
        end
        if H2 > 0
            W2 = nchoosek(1:H2+M-1,M-1) - repmat(0:M-2,nchoosek(H2+M-1,M-1),1) - 1;
            W2 = ([W2,zeros(size(W2,1),1)+H2]-[zeros(size(W2,1),1),W2])/H2;
            W  = [W;W2/2+1/(2*M)];
        end
    end
    W = max(W,1e-6);
    N = size(W,1);
end
%%
function W = T_repeat(k,M)
%产生(约)k个M维的向量,向量的每维取值均匀分布于[0,1]上,每一种组合对应一个向量
    if M > 1
        k = (ceil(k^(1/M)))^M;
        Temp = 0:1/(k^(1/M)-1):1;
        code = '[c1';
        for i = 2 : M
            code = [code,',c',num2str(i)];
        end
        code = [code,']=ndgrid(Temp);'];
        eval(code);
        code = 'W=[c1(:)';
        for i = 2 : M
            code = [code,',c',num2str(i),'(:)'];
        end
        code = [code,'];'];
        eval(code);
    else
        W = [0:1/(k-1):1]';
    end
end

function FunctionValue = T_sort(FunctionValue)
%选出种群中的所有非支配个体
    Choose = true(1,size(FunctionValue,1));
    [~,rank] = sortrows(FunctionValue);
    for i = rank'
        for j = rank(find(rank==i)+1:end)'
            if Choose(j)
                k = 1;
                for m = 2 : size(FunctionValue,2)
                    if FunctionValue(i,m) > FunctionValue(j,m)
                        k = 0;
                        break;
                    end
                end
                if k == 1
                    Choose(j) = false;
                end
            end
        end
    end
    FunctionValue = FunctionValue(Choose,:);
end