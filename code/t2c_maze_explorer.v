// Task 2C - MazeSolver Bot

module t2c_maze_explorer (
    input clk,
    input rst_n,
    input left,
    mid,
    right,  // 0 - no wall, 1 - wall
    output reg [2:0] move
);

  /*

        | cmd | move  | meaning   |
        |-----|-------|-----------|
        | 000 | 0     | STOP      |
        | 001 | 1     | FORWARD   |
        | 010 | 2     | LEFT      |
        | 011 | 3     | RIGHT     | 
        | 100 | 4     | U_TURN    |

        START POS   : 4,0
        EXIT POS    : 4,8
        DEADENDS    : 9

        */
  //////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////
  // IDLE 


  parameter IDLE = 3'b000;
  parameter START = 3'b001;
  parameter MOVE = 3'b010;
  parameter DECIDE = 3'b011;

  parameter STOP = 3'b000;
  parameter FORWARD = 3'b001;
  parameter LEFT = 3'b010;
  parameter RIGHT = 3'b011;
  parameter U_TURN = 3'b100;
  reg [2:0] state, next_state;
  reg [1:0] flag;
  reg mark[0:8][0:8];  // 0 unvisited  1 visited  2 deadend
  reg [1:0] dirn;  //  0 N 1 E  2 S  3 W
  reg [3:0] x_pos, y_pos, prev_x, prev_y;
  reg signed [3:0] dir_x[3:0], dir_y[3:0];
  integer i, j;
  reg [1:0] ways_blocked, ways;
  reg block;
  reg flag2;

  initial begin
    state = IDLE;
    move  = STOP;
    flag  = 0;
    for (i = 0; i < 9; i = i + 1) begin
      for (j = 0; j < 9; j = j + 1) begin
        mark[i][j] = 0;  // unvisited
      end
    end
    mark[4][8] = 1;
    dirn = 2'b00;  // facing north
    x_pos = 4;
    y_pos = 8;
    prev_x = 4;
    prev_y = 8;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
      for (i = 0; i < 9; i = i + 1) begin
        for (j = 0; j < 9; j = j + 1) begin
          mark[i][j] <= 0;  // unvisited
        end
      end
      mark[4][8] <= 1;
      dirn <= 2'b00;
      x_pos <= 4;
      y_pos <= 8;
      prev_x <= 4;
      prev_y <= 8;
      flag <= 0;
      flag2 <= 0;
    end else begin
      flag  <= flag + 1;
      state <= next_state;
      if (state == START) begin
        move <= STOP;
      end else if (state == DECIDE) begin
        prev_x <= x_pos;
        prev_y <= y_pos;
        if (mark[prev_x][prev_y] && block) begin
          mark[x_pos][y_pos] <= 1;
        end
        flag <= 0;
        if (x_pos == 4 && y_pos == 0) begin
          if (!flag2) begin
            flag2 <= 1;
            if ((!left + !mid + !right == 1)) begin
              x_pos <= x_pos + dir_x[3];
              y_pos <= y_pos + dir_y[3];
              dirn  <= (dirn + 2) % 4;
              move  <= U_TURN;
            end else if (!left && dirn != 1 && !mark[x_pos+dir_x[0]][y_pos+dir_y[0]]) begin
              x_pos <= x_pos + dir_x[0];
              y_pos <= y_pos + dir_y[0];
              dirn  <= (dirn + 3) % 4;
              move  <= LEFT;
            end else if ( !mid && dirn != 0 && !mark[x_pos+dir_x[1]][y_pos+dir_y[1]]) begin
              x_pos <= x_pos + dir_x[1];
              y_pos <= y_pos + dir_y[1];
              move  <= FORWARD;
            end else if ( !right && dirn != 3 && !mark[x_pos+dir_x[2]][y_pos+dir_y[2]]) begin
              x_pos <= x_pos + dir_x[2];
              y_pos <= y_pos + dir_y[2];
              dirn  <= (dirn + 1) % 4;
              move  <= RIGHT;
            end
          end else if (!left && (x_pos + dir_x[0] == 4) && (y_pos + dir_y[0] == -1)) begin
            x_pos <= x_pos + dir_x[0];
            y_pos <= y_pos + dir_y[0];
            dirn  <= (dirn + 3) % 4;
            move  <= LEFT;
          end else if (!mid && (x_pos + dir_x[1] == 4) && (y_pos + dir_y[1] == -1)) begin
            x_pos <= x_pos + dir_x[1];
            y_pos <= y_pos + dir_y[1];
            move  <= FORWARD;
          end else if (!right && (x_pos + dir_x[2] == 4) && (y_pos + dir_y[2] == -1)) begin
            x_pos <= x_pos + dir_x[2];
            y_pos <= y_pos + dir_y[2];
            dirn  <= (dirn + 1) % 4;
            move  <= RIGHT;
          end else if (!left && !mark[x_pos+dir_x[0]][y_pos+dir_y[0]]) begin
            x_pos <= x_pos + dir_x[0];
            y_pos <= y_pos + dir_y[0];
            dirn  <= (dirn + 3) % 4;
            move  <= LEFT;
          end else if (!mid && !mark[x_pos+dir_x[1]][y_pos+dir_y[1]]) begin
            x_pos <= x_pos + dir_x[1];
            y_pos <= y_pos + dir_y[1];
            move  <= FORWARD;
          end else if (!right && !mark[x_pos+dir_x[2]][y_pos+dir_y[2]]) begin
            x_pos <= x_pos + dir_x[2];
            y_pos <= y_pos + dir_y[2];
            dirn  <= (dirn + 1) % 4;
            move  <= RIGHT;
          end
        end else if (!left && !mark[x_pos+dir_x[0]][y_pos+dir_y[0]]) begin
          x_pos <= x_pos + dir_x[0];
          y_pos <= y_pos + dir_y[0];
          dirn  <= (dirn + 3) % 4;
          move  <= LEFT;
        end else if (!mid && !mark[x_pos+dir_x[1]][y_pos+dir_y[1]]) begin
          x_pos <= x_pos + dir_x[1];
          y_pos <= y_pos + dir_y[1];
          move  <= FORWARD;
        end else if (!right && !mark[x_pos+dir_x[2]][y_pos+dir_y[2]]) begin
          x_pos <= x_pos + dir_x[2];
          y_pos <= y_pos + dir_y[2];
          dirn  <= (dirn + 1) % 4;
          move  <= RIGHT;
        end else begin
          x_pos <= x_pos + dir_x[3];
          y_pos <= y_pos + dir_y[3];
          mark[x_pos][y_pos] <= 1;
          dirn <= (dirn + 2) % 4;
          move <= U_TURN;
        end
      end
    end
  end
  always @(*) begin
    ways_blocked=(!left && mark[x_pos+dir_x[0]][y_pos+dir_y[0]]) +
    (!mid && mark[x_pos+dir_x[1]][y_pos+dir_y[1]]) + (!right && mark[x_pos+dir_x[2]][y_pos+dir_y[2]]);
    ways = !left + !mid + !right;
    block = (ways_blocked + 1 == ways);
    case (dirn)
      2'b00: begin
        dir_x[0] = -1;
        dir_y[0] = 0;
        dir_x[1] = 0;
        dir_y[1] = -1;
        dir_x[2] = 1;
        dir_y[2] = 0;
        dir_x[3] = 0;
        dir_y[3] = 1;
      end
      2'b01: begin
        dir_x[0] = 0;
        dir_y[0] = -1;
        dir_x[1] = 1;
        dir_y[1] = 0;
        dir_x[2] = 0;
        dir_y[2] = 1;
        dir_x[3] = -1;
        dir_y[3] = 0;
      end
      2'b10: begin
        dir_x[0] = 1;
        dir_y[0] = 0;
        dir_x[1] = 0;
        dir_y[1] = 1;
        dir_x[2] = -1;
        dir_y[2] = 0;
        dir_x[3] = 0;
        dir_y[3] = -1;
      end

      2'b11: begin
        dir_x[0] = 0;
        dir_y[0] = 1;
        dir_x[1] = -1;
        dir_y[1] = 0;
        dir_x[2] = 0;
        dir_y[2] = -1;
        dir_x[3] = 1;
        dir_y[3] = 0;
      end


    endcase

    case (state)
      IDLE: begin
        if (rst_n) begin
          next_state = START;
        end
      end
      START: begin
        if (flag == 2'b01) begin
          next_state = DECIDE;
        end else begin
          next_state = START;
        end
      end

      MOVE: begin
        next_state = DECIDE;
      end
      DECIDE: begin
        next_state = MOVE;
      end
    endcase
  end



  //////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
