import { Module } from '@nestjs/common';
import TestController from './presentation/controllers/TestController';

@Module({
    imports: [],
    controllers: [TestController],
    providers: [],
})
export class AppModule {}
