function output = convertBase(symbolInput)

    output = 0;
    for i = 1 : length(symbolInput)
        output = output + symbolInput(i,1)*(2^(i-1));
    end
end