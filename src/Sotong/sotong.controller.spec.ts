import { Test, TestingModule } from '@nestjs/testing';
import { SotongController } from './sotong.controller';

describe('SotongController', () => {
  let controller: SotongController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SotongController],
    }).compile();

    controller = module.get<SotongController>(SotongController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
