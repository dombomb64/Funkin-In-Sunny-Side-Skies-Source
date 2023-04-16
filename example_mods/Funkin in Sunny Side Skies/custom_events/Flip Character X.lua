function onEvent(name, value1, value2)
    if name == 'Flip Character X' then
        local character = 'boyfriend';
        if value1 == 'girlfriend' or value1 == 'gf' then
            character = 'gf';
        elseif value1 == 'boyfriend2' or value1 == 'bf2' then
            character = 'boyfriend2';
        elseif value1 == 'dad' or value1 == 'opponent' then
            character = 'dad';
        elseif value1 == 'dad2' or value1 == 'opponent2' then
            character = 'dad2';
        end
        setProperty(character .. '.flipX', not (getProperty(character .. '.flipX')));
    end
end