clear
N = 10;  % Maximum number of alphabetizing iterations

%% Create Figure
f = figure;
hold on
c = colormap(hsv(26));

%% Initialize Alphabet and Metadata
alphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',...
            'p','q','r','s','t','u','v','w','x','y','z'};
alphabet_order = 1:26;
% letter_names = {'a','bee','cee','dee','e','ef','gee','aitch','i','jay',...
%                 'kay','el','em','en','o','pee','cue','ar','ess','tee',...
%                 'u','vee','doubleu','ex','wy','zee'};
letter_names = {'ay','bee','see','dee','ee','eff','jee','aitch','aye','jay',...
    'kay','ell','em','en','oh','pee','queue','arr','ess','tee',...
    'yu','vee','doubleyu','ecks','wie','zee'};
            
% Initialize the total permutation vector.  This will let us get back to the
% original alphabet when we need to.
Ptot = 1:26;

%% Plot the Initial Alphabet
text(1,0,strjoin(alphabet),'FontName','Courier','FontSize',20,'FontWeight','bold')

%% Alphabetize the Alphabet Based on the Current Alphabet
for n = 1:N
    % Initialize the sorting values.
    string_value = zeros(1,26);
    for i = 1:26
        
        % Get the name of letter i.
        string = letter_names{i};
        
        % Next, we convert the letter name into a 7 digit big-endian
        % base-26 number:
        
        % letter_1*(26^7) + letter_2*(26^6) ... + letter_7*(26^0)
        
        % This ensures that the first letter is always more
        % significant than the following letters, and so-on for each
        % successive letter.
        for j = length(string):-1:1
            
            % Get the index of letter j in the name of letter i.
            for k = 1:26
                letter_find(k) = strcmp(alphabet{k},string(j));
            end
            letter_value = find(letter_find);
            
            % Add the scaled letter value to the sorting value of the name
            % of letter i.
            string_value(i) = string_value(i) + letter_value*26^(9-j);
        end
        
        % string_value(i) now contains the sorting value of the name of
        % letter i.
    end
    
    % Get the permutation vector which alphabetizes the alphabet.
    [~,P] = sort(string_value);
    
    % Update the total permutation vector.
    Ptot = Ptot(P);
    
    % Check whether we changed the alphabet order.  If not, the algorithm
    % converged and we can stop.
    if alphabet_order==alphabet_order(P)
        disp('Sort Converged')
        break
    end
    
    % Update the alphabet and metadata order using the permuation vector
    alphabet = alphabet(P);
    alphabet_order = alphabet_order(P);
    letter_names = letter_names(P);
    
    % Plot lines tracking the change in letter positions.
    for i = 1:26
        plot([i+.25 P(i)+.25],[n-.05 n-0.95],'-','Color',c(Ptot(i),:),'LineWidth',2)
    end
    % Plot the new alphabetized alphabet
    text(1,n,strjoin(alphabet),'FontName','Courier','FontSize',20,'FontWeight','bold')
end

%% Finalize the Plot
set(f, 'Position', [1000,603,1094,735])
set(gca,'YDir','reverse')
ylim([-0.05 n-0.95])
xlim([0.5 27])
set(gca,'XColor','none','YColor','none')