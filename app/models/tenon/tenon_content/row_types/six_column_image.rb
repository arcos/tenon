module Tenon
  module TenonContent
    module RowTypes
      class SixColumnImage < TenonContent::RowTypes::Base
        class << self
          def add_pieces_to(row)
            if row.pieces.empty?
              row.pieces.build(piece_type: 'Image', position: 0)
              row.pieces.build(piece_type: 'Image', position: 1)
              row.pieces.build(piece_type: 'Image', position: 2)
              row.pieces.build(piece_type: 'Image', position: 3)
              row.pieces.build(piece_type: 'Image', position: 4)
              row.pieces.build(piece_type: 'Image', position: 5)
            end
          end
        end
      end
    end
  end
end
