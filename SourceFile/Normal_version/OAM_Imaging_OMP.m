   %   %       D   E   M   O       -       V   o   r   t   e   x       w   a   v   e       2   D       t   a   r   g   e   t       i   m   a   g   i   n   g       b   a   s   e   d       o   n       O   M   P   
   %   
   %       H   i   s   t   o   r   y       :   
   %               Y   a   o       -       2   0   2   1   .   6   .   1   4       -       v   1   .   0   
   %                               1   .   C   r   e   a   t   e       F   i   l   e   
   
   %   %   
   c   l   c   ;   c   l   e   a   r   ;   c   l   o   s   e       a   l   l   ;           
   
   %   %       S   e   t   t   i   n   g       P   a   r   a   m   e   t   e   r   s   
   %       B   a   s   i   c   
   m   o   d   e   R   a   n   g   e       =       1   0   ;   
   f   0       =       9   e   9   ;   
   
   c       =       2   9   9   7   9   2   4   5   8   ;   
   l   a   m   b   d   a       =       c       /       f   0       ;   
   k       =       2   .   0       *       p   i       /       l   a   m   b   d   a   ;       
   
   %       T   a   r   g   e   t   
   t   h   e   t   a       =   0   .   3   *   p   i   ;   
   s   c   a   t   t   e   r   i   n   g   P   o   i   n   t   N   u   m       =       2   ;   
   m   R   a   d   i   u   s       =       [   6   0   0   ,   8   0   0   ]   ;   
   m   E   l   e   v   a   t   i   o   n       =       t   h   e   t   a       *       o   n   e   s   (   1   ,   s   c   a   t   t   e   r   i   n   g   P   o   i   n   t   N   u   m   )   ;   
   m   A   z   i   m   u   t   h       =       [   3   0   ,   8   0   ]   /   1   8   0   *   p   i   ;   
   
   %   %       P   a   r   a   m   e   t   e   r   s   
   N       =       1   0   2   4   ;   
   e   l   e   m   N   u   m       =       m   o   d   e   R   a   n   g   e       *       2       +       2   ;   
   a   r   r   R   a   d   i   u   s       =       2   5   *   l   a   m   b   d   a   ;   
   
   T   p       =       1   e   -   6   ;       
   T   r       =       2   e   -   6   ;       
   B   =   1   8   0   e   6   ;   
   f   s   =   4   *   B   ;   
   n   S   t   e   p   p   e   d   F   r   e   q       =       6   1   ;   
   
   R   m   i   n   =   5   0   0   ;   R   m   a   x   =   1   0   0   0   ;       
   R   c   o   u   n   t       =       8   0   ;   
   
   P   h   i   M   i   n       =       0   ;   P   h   i   M   a   x       =       p   i   ;   
   P   h   i   c   o   u   n   t       =       6   0   ;   
   
   %   %       C   o   m   p   u   t   e   d       P   a   r   a   m   e   t   e   r   s   
   m   o   d   e   s       =       -   m   o   d   e   R   a   n   g   e   :   1   :   m   o   d   e   R   a   n   g   e       ;   
   r   c   s       =       o   n   e   s   (   1   ,   s   c   a   t   t   e   r   i   n   g   P   o   i   n   t   N   u   m   )   ;   
   
   t   s       =       1   /   f   s   ;   
   s   a   m   p   l   e   N   u   m       =       c   e   i   l   (   (   2   *   (   R   m   a   x   -   R   m   i   n   )   /   c   )   /   t   s   )   ;   
   s   a   m   p   l   e   N   u   m   _   f   f   t       =       2   ^   n   e   x   t   p   o   w   2   (   2   *   s   a   m   p   l   e   N   u   m   -   1   )   ;   
   t   a   o       =       2   *   m   R   a   d   i   u   s   '   /   c   ;   
   t       =       l   i   n   s   p   a   c   e   (   2   *   R   m   i   n   /   c   ,   2   *   R   m   a   x   /   c   ,   s   a   m   p   l   e   N   u   m   )   ;       
   t   d       =       o   n   e   s   (   s   c   a   t   t   e   r   i   n   g   P   o   i   n   t   N   u   m   ,   1   )   *   t   -   t   a   o   *   o   n   e   s   (   1   ,   s   a   m   p   l   e   N   u   m   )   ;   
   
   %   %       O   b   s   e   r   v   a   t   i   o   n       p   l   a   n   e   
   R       =       l   i   n   s   p   a   c   e   (   R   m   i   n   ,   R   m   a   x   ,   R   c   o   u   n   t   )   ;   
   P   h   i       =       l   i   n   s   p   a   c   e   (   P   h   i   M   i   n   ,   P   h   i   M   a   x   ,   P   h   i   c   o   u   n   t   )   ;   
   Q       =       R   c   o   u   n   t       *       P   h   i   c   o   u   n   t   ;   
   [   r   ,   p   h   i   ]       =       m   e   s   h   g   r   i   d   (   R   ,   P   h   i   )   ;   
   
   %   %       M   e   a   s   u   r   e   m   e   n   t       v   e   c   t   o   r   
   S   r       =       z   e   r   o   s   (   1   ,   l   e   n   g   t   h   (   m   o   d   e   s   )   *   s   a   m   p   l   e   N   u   m   )   ;   
   
   f   o   r       i       =       1   :   l   e   n   g   t   h   (   m   o   d   e   s   )   
                   m   o   d   e       =       m   o   d   e   s   (   i   )   ;   
                   n   P   u   l   s   e       =       f   l   o   o   r   (   t   d   /   T   r   )   ;   
                   d   f       =       B       /       (   n   S   t   e   p   p   e   d   F   r   e   q   -   1   )   ;   
                   f       =       f   0       +       n   P   u   l   s   e       *       d   f       ;       
                   r   e   c   t       =       1   *   (   a   b   s   (   m   o   d   (   t   d   +   T   p   /   2   ,   T   r   )   )   <   T   p   )   ;   
                   S   r   (   (   i   -   1   )   *   s   a   m   p   l   e   N   u   m   +   1   :   i   *   s   a   m   p   l   e   N   u   m   )       =       r   c   s       *       (   .   .   .   
                                   r   e   c   t   .   *   e   x   p   (   1   i   *   2   .   0   *   p   i   *   t   d   .   *   f   )   .   .   .   
                                   .   *       b   e   s   s   e   l   j   (   m   o   d   e   ,   f   *   2   *   p   i   *   a   r   r   R   a   d   i   u   s   .   *   s   i   n   (   m   E   l   e   v   a   t   i   o   n   '   )   /   c   )   .   ^   2       .   .   .   
                                   .   *       e   x   p   (   1   i   *   2   .   0   *   m   o   d   e   *   (   m   A   z   i   m   u   t   h   '   )   )   )   ;   
   e   n   d   
   
   t   M   a   t       =       r   e   p   m   a   t   (   t   ,   1   ,   l   e   n   g   t   h   (   m   o   d   e   s   )   )   ;   
   S   r       =       (   S   r   .   /   e   x   p   (   -   1   i   *   2   *   p   i   *   f   0   *   t   M   a   t   )   )   '   ;   
   
   %   %       C   o   m   p   r   e   s   s   i   v   e       s   e   n   s   i   n   g       m   a   t   r   i   x   
   S       =       z   e   r   o   s   (   l   e   n   g   t   h   (   S   r   )   ,   Q   )   ;   
   f   o   r       i       =       1   :       Q   
                   g   T   d   =   t   -   2   *   r   (   i   )   /   c   *   o   n   e   s   (   1   ,   s   a   m   p   l   e   N   u   m   )   ;   
                   S   t   m   p       =       z   e   r   o   s   (   1   ,   l   e   n   g   t   h   (   m   o   d   e   s   )   *   s   a   m   p   l   e   N   u   m   )   ;   
                   f   o   r       j       =       1   :   l   e   n   g   t   h   (   m   o   d   e   s   )   
                                   m   o   d   e       =       m   o   d   e   s   (   j   )   ;   
                                   n   P   u   l   s   e       =       f   l   o   o   r   (   g   T   d   /   T   r   )   ;   
                                   d   f       =       B       /       (   n   S   t   e   p   p   e   d   F   r   e   q   -   1   )   ;   
                                   f       =       f   0       -   B   /   2       +       n   P   u   l   s   e       *       d   f       ;       
                                   r   e   c   t       =       1   *   (   a   b   s   (   m   o   d   (   g   T   d   +   T   p   /   2   ,   T   r   )   )   <   T   p   )   ;   
                                   S   t   m   p   (   (   j   -   1   )   *   s   a   m   p   l   e   N   u   m   +   1   :   j   *   s   a   m   p   l   e   N   u   m   )       =       1       *       (   .   .   .   
                                                   r   e   c   t   .   *   e   x   p   (   1   i   *   2   .   0   *   p   i   *   g   T   d   .   *   f   )   .   .   .   
                                                   .   *       b   e   s   s   e   l   j   (   m   o   d   e   ,   f   *   2   *   p   i   *   a   r   r   R   a   d   i   u   s   .   *   s   i   n   (   t   h   e   t   a   '   )   /   c   )   .   ^   2       .   .   .   
                                                   .   *       e   x   p   (   1   i   *   2   .   0   *   m   o   d   e   *   (   p   h   i   (   i   )   '   )   )   )   ;   
                   e   n   d   
                   S   (   :   ,   i   )       =       (   S   t   m   p   .   /   e   x   p   (   -   1   i   *   2   *   p   i   *   f   0   *   t   M   a   t   )   )   '   ;   
   e   n   d   
   
   P   s   i       =   e   y   e   (   Q   )   ;   
   A       =       S       *       P   s   i   ;   
   
   %   %       O   M   P   
   t   h   e   t   a       =       z   e   r   o   s   (   s   i   z   e   (   A   ,   2   )   ,   1   )   ;   
   a   u   g       =       [   ]   ;   
   y       =       S   r   ;   
   r   _   n       =       y   ;   
   t   h   e   t   a   _   p   o   s       =       s   i   z   e   (   1   ,   s   c   a   t   t   e   r   i   n   g   P   o   i   n   t   N   u   m   )   ;   
   
   f   o   r       i       =       1   :       s   c   a   t   t   e   r   i   n   g   P   o   i   n   t   N   u   m   
                   p   r   o   d   u   c   t           =       a   b   s   (   A   '       *       r   _   n   )   ;   
   	   [   ~   ,       p   o   s   ]       =       m   a   x   (   a   b   s   (   p   r   o   d   u   c   t   )   )   ;   
   	   a   u   g       =       [   a   u   g       A   (   :   ,   p   o   s   )   ]   ;   
   	   A   (   :   ,   p   o   s   )       =       z   e   r   o   s   (   s   i   z   e   (   A   ,   1   )   ,   1   )   ;   
   	   t   h   e   t   a   _   l   s   =   (   a   u   g   '   *   a   u   g   )   ^   (   -   1   )   *   a   u   g   '   *   y   ;   
   	   r   _   n       =       y   -   a   u   g   *   t   h   e   t   a   _   l   s   ;   
   	   t   h   e   t   a   _   p   o   s   (   i   )   =   p   o   s   ;   
   e   n   d   
   
   t   h   e   t   a   (   t   h   e   t   a   _   p   o   s   )       =       t   h   e   t   a   _   l   s       ;   
   
   r   e   s       =       r   e   s   h   a   p   e   (   P   s   i       *       t   h   e   t   a   ,   [   P   h   i   c   o   u   n   t   ,   R   c   o   u   n   t   ]   )   ;   
   
   %   %       P   l   o   t   
   f   i   g   u   r   e   (   1   )   ;   
   s   u   r   f   (   R   ,   P   h   i   /   p   i   *   1   8   0   ,   a   b   s   (   r   e   s   )   )   
   s   h   a   d   i   n   g       i   n   t   e   r   p   ;   
   x   l   a   b   e   l   (   '   R   a   n   g   e   /   m   '   )   ;   y   l   a   b   e   l   (   '   A   z   i   m   u   t   h   /   �   '   )   ;   t   i   t   l   e   (   '   2   D       i   m   a   g   i   n   g   (   O   M   P   )   '   )   ;   
   v   i   e   w   (   2   )   ;